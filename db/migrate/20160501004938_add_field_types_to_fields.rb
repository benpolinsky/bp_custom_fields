class AddFieldTypesToFields < ActiveRecord::Migration
  def change
    add_column :bp_custom_fields_fields, :field_type, :integer, default: 0
  end
end
