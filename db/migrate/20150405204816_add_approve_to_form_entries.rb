class AddApproveToFormEntries < ActiveRecord::Migration
  def change
    add_column :form_entries, :approve, :boolean, default: false
    add_reference :form_entries, :approver, index: true
  end
end
