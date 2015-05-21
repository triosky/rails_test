# == Schema Information
#
# Table name: forms
#
#  id           :integer          not null, primary key
#  creator_id   :integer
#  company_id   :integer
#  name         :string(255)
#  introduction :text
#  created_at   :datetime
#  updated_at   :datetime
#  icon         :string(255)
#

class Form < ActiveRecord::Base
  extend Enumerize

  # relationship
  belongs_to :creator, class_name: 'User '
  belongs_to :company
  has_many   :fields,     class_name: 'FormField',    dependent: :destroy
  has_many   :approvals,  class_name: 'FormApproval', dependent: :destroy
  has_many   :approvers,  class_name: 'User',         through: :approvals, source: :approver
  has_many   :entries,    class_name: 'FormEntry',    dependent: :destroy

  # accept nested
  accepts_nested_attributes_for :fields,    reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :approvals, reject_if: :all_blank, allow_destroy: true

  # validation
  validates :name,  presence: true,
                    uniqueness: { case_sensitive: false, scope: :company_id }

end
