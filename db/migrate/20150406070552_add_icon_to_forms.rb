class AddIconToForms < ActiveRecord::Migration
  def change
    add_column :forms, :icon, :string
  end
end
