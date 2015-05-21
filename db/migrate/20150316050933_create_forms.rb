class CreateForms < ActiveRecord::Migration
  def change
    create_table :forms do |t|
      t.references  :creator
      t.references  :company
      t.string      :name
      t.text        :introduction
      t.timestamps
    end
  end
end
