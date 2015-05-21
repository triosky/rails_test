# == Schema Information
#
# Table name: form_approvals
#
#  id          :integer          not null, primary key
#  form_id     :integer
#  approver_id :integer
#  role        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class FormApproval < ActiveRecord::Base
  extend Enumerize

  # capabilities
  enumerize :role,  in: Enum::FormApproval::ROLE[:options],
                    default: Enum::FormApproval::ROLE[:default],
                    predicates: { prefix: true }

  # relationships
  belongs_to :form
  belongs_to :approver, class_name: 'User'

end
