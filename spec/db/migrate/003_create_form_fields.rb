class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :form_fields do |t|
      t.belongs_to :form, null: false
      t.string :name, null: false
      t.string :field_type, null: false
      t.integer :position, null: false
      t.boolean :required, null: false, default: false
      t.hstore :properties, null: false
    end
  end
end
