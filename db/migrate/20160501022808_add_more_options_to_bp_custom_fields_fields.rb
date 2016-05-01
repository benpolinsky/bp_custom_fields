class AddMoreOptionsToBpCustomFieldsFields < ActiveRecord::Migration
  def change
    add_column :bp_custom_fields_fields, :min, :string
    add_column :bp_custom_fields_fields, :max, :string
    add_column :bp_custom_fields_fields, :required, :boolean
    add_column :bp_custom_fields_fields, :instructions, :text
    add_column :bp_custom_fields_fields, :default_value, :text
    add_column :bp_custom_fields_fields, :placeholder_text, :text
    add_column :bp_custom_fields_fields, :prepend, :string
  end
end
