class ChangeEntryApprovals < ActiveRecord::Migration
  def up
    remove_column :form_entries, :approve
    add_column :form_entries, :status, :string, default: 'pending'
  end

  def down
    remove_column :form_entries, :status
    add_column :form_entries, :approve, :boolean, default: false
  end
end
