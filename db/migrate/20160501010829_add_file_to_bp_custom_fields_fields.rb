class AddFileToBpCustomFieldsFields < ActiveRecord::Migration
  def change
    add_column :bp_custom_fields_fields, :file, :string
  end
end
