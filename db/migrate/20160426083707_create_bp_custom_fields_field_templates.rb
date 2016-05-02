class CreateBpCustomFieldsFieldTemplates < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_field_templates do |t|
      t.string :name
      t.string :label
      t.references :group_template, index: true, foreign_key: true
      t.integer :field_type, default: nil
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
