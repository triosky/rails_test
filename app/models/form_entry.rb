# == Schema Information
#
# Table name: form_entries
#
#  id          :integer          not null, primary key
#  form_id     :integer
#  user_id     :integer
#  answers     :hstore
#  created_at  :datetime
#  updated_at  :datetime
#  approver_id :integer
#  status      :string(255)      default("pending")
#

class FormEntry < ActiveRecord::Base
  extend Enumerize
  include PublicActivity::Model
  enumerize :status,  in: Enum::FormEntry::STATUS[:options],
                      default: Enum::FormEntry::STATUS[:default],
                      predicates: { prefix: true }

  serialize :answers, ActiveRecord::Coders::NestedHstore

  # relationship
  belongs_to :user
  belongs_to :form
  belongs_to :approver, class_name: 'User'


  # validation
  validates :form, presence: true
  validates :user, presence: true
  validate  :validate_answers

  # callbacks
  before_validation :process_answers

  # cache the fields in variable
  def fields
    @fields ||= form.fields
  end

  def can_approve?(user)
    form.approvers.include?(user) && status_pending?
  end


  def validate_answers
    fields.each_with_index do |field, idx|
      case field.field_type
      when 'single_line', 'paragraph', 'website', 'radio', 'date', 'picture_choice', 'dropdown', 'rating', 'boolean', 'file'
        if field.required && answers[field.id.to_s].blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

      when 'checkbox'
        if field.required && (answers[field.id.to_s] || []).reject(&:blank?).blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

      when 'price'
        if field.required && answers[field.id.to_s].blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

        if answers[field.id.to_s].present? && answers[field.id.to_s].try(:to_f) < 0
          errors[:base] << "#{idx+1}) #{field.field_label} should be greater or equal than 0"
        end

      when 'website'
        if field.required && answers[field.id.to_s].blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

      when 'percentage', 'number'
        if field.required && answers[field.id.to_s].blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

        if answers[field.id.to_s].present? && field.properties['from_number'].present? && field.properties['to_number'].present?
          value       = answers[field.id.to_s].to_f
          from_number = field.properties['from_number'].to_f
          to_number   = field.properties['to_number'].to_f

          if (value < from_number)
            errors[:base] << "#{idx+1}) #{field.field_label} can't be lower than #{ from_number }"
          end

          if (value > to_number)
            errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_greater_than'} #{ to_number }"
          end
        end

      when 'range'
        if field.required && (answers[field.id.to_s]['from'].blank? || answers[field.id.to_s]['to'].blank?)
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

        if answers[field.id.to_s]['from'].present? && answers[field.id.to_s]['to'].present?
          value1 = answers[field.id.to_s]['from'].to_f
          value2 = answers[field.id.to_s]['to'].to_f

          from_number = field.properties['from_number'].to_f
          to_number   = field.properties['to_number'].to_f

          if ((from_number != 0.0) && ((value1 <= from_number) || (value1 >= to_number))) || ((to_number != 0.0) && ((value2 >= to_number) || (value2 <= from_number)))
            errors[:base] << "#{idx+1}) #{field.field_label} values should be between #{ from_number.to_i } and #{ to_number.to_i }"
          end
        end

      when 'email'
        if field.required && answers[field.id.to_s].blank?
          errors[:base] << "#{idx+1}) #{field.field_label} #{I18n.t 'errors.cant_be_blank'}"
        end

        if answers[field.id.to_s].present? && answers[field.id.to_s].match(/\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/).blank?
          errors[:base] << "#{idx+1}) #{field.field_label} is not a valid email format"
        end

      when 'datetime'
        if field.required
          if answers[field.id.to_s]['date'].blank? || answers[field.id.to_s]['hours'].blank? || answers[field.id.to_s]['minutes'].blank?
            errors[:base] << "#{idx+1}) #{field.field_label} for date, hours, and minutes #{I18n.t 'errors.cant_be_blank'}"
          end
        end

      end
    end
  end


  private

  # Callback to process answer entries for all types that need a process
  #
  def process_answers
    if self.answers.present?
      fields.each do |field|
        # remove nil values
        if field.field_type_checkbox?
          self.answers[field.id.to_s] =  if self.answers[field.id.to_s].is_a?(String)
                                           JSON.parse(self.answers[field.id.to_s]).reject(&:blank?).uniq
                                         elsif self.answers[field.id.to_s].is_a?(Array)
                                           self.answers[field.id.to_s].reject(&:blank?).uniq
                                         end

        # Process to store attachment file
        elsif field.field_type_file?
          data = self.answers[field.id.to_s]
          if data.present?
            uploader = AttachmentUploader.new
            uploader.question_id = field.id.to_s
            uploader.form_id = form_id
            uploader.store!(data)
            self.answers[field.id.to_s] = uploader.url
          end
        end
      end
    end
  end

end
