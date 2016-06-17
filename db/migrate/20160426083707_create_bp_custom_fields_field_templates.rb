class CreateBpCustomFieldsFieldTemplates < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_field_templates do |t|
      t.string :name
      t.string :label
      t.references :bp_custom_fields_group_templates, foreign_key: true, index: { name: 'bpf_ft_gt' }
      t.integer :field_type, default: nil
      t.string :min
      t.string :max
      t.boolean :required
      t.text :instructions
      t.text :default_value
      t.text :placeholder_text
      t.string :prepend
      t.string :append
      t.integer :rows
      t.string :date_format
      t.string :time_format
      t.string :accepted_file_types
      t.string :toolbar
      t.text :choices
      t.boolean :multiple
      t.integer :parent_id
      t.timestamps null: false
      t.integer :row_order
    end
  end
end
