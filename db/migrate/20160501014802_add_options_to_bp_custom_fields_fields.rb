class AddOptionsToBpCustomFieldsFields < ActiveRecord::Migration
  def change
    add_column :bp_custom_fields_fields, :options, :text
  end
end
