# == Schema Information
#
# Table name: form_fields
#
#  id         :integer          not null, primary key
#  form_id    :integer
#  field_type :string(255)
#  name       :string(255)
#  required   :boolean          default(FALSE)
#  properties :hstore
#  position   :integer
#  created_at :datetime
#  updated_at :datetime
#

class FormField < ActiveRecord::Base
  include Concerns::FormField::FieldTypeCollection

  # attributes
  serialize :properties,  ActiveRecord::Coders::NestedHstore

  # relationship
  belongs_to :form
  has_many   :field_options, dependent: :destroy

  # accept nested attributes
  accepts_nested_attributes_for :field_options, reject_if: :all_blank, allow_destroy: true

  # validation
  validates :position,  presence: true
  validates :name,      presence: true,
                        uniqueness: { case_sensitive: false, scope: :form_id }


  # instances methods
  # -----------------------------
  def as_json(options = {})
    super(options).merge(persisted: persisted?, field_options: field_options.map{|x| x.as_json})
  end

end
