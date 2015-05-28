class CreateFormEntries < ActiveRecord::Migration
  def change
    create_table :form_entries do |t|
      t.belongs_to :form, null: false
      t.hstore :answers, null: false
    end
  end
end
