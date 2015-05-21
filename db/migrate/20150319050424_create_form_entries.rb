class CreateFormEntries < ActiveRecord::Migration
  def change
    create_table :form_entries do |t|
      t.references  :form, index: true
      t.references  :user, index: true
      t.hstore      :answers
      t.timestamps
    end
  end
end
