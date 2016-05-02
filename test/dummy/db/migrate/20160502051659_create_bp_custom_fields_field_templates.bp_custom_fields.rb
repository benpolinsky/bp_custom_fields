# This migration comes from bp_custom_fields (originally 20160426083707)
class CreateBpCustomFieldsFieldTemplates < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_field_templates do |t|
      t.string :name
      t.string :label
      t.text :value
      t.references :group_template, index: true, foreign_key: true
      t.integer :field_type, default: nil
      t.string :file
      t.text :options
      t.string :min
      t.string :max
      t.boolean :required
      t.text :instructions
      t.text :default_value
      t.text :placeholder_text
      t.string :prepend
      t.timestamps null: false
    end
  end
end
