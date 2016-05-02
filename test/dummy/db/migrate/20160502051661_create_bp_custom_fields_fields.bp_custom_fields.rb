# This migration comes from bp_custom_fields (originally 20160502045705)
class CreateBpCustomFieldsFields < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_fields do |t|
      t.references :field_template, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.text :value

      t.timestamps null: false
    end
  end
end
