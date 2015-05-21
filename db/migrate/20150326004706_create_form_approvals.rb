class CreateFormApprovals < ActiveRecord::Migration
  def change
    create_table :form_approvals do |t|
      t.references :form
      t.references :approver
      t.string     :role
      t.timestamps
    end
  end
end
