class CreateFormFields < ActiveRecord::Migration
  def change
    create_table :form_fields do |t|
      t.references   :form
      t.string       :field_type
      t.string       :name
      t.boolean      :required, default: false
      t.hstore       :properties
      t.integer      :position
      t.timestamps
    end
  end
end
