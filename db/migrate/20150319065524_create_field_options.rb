class CreateFieldOptions < ActiveRecord::Migration
  def change
    create_table :field_options do |t|
      t.references :form_field
      t.string  :name
      t.string  :picture
      t.timestamps
    end
  end
end
