class AddAppearsOnToBpCustomFieldsGroupTemplate < ActiveRecord::Migration
  def change
    add_column :bp_custom_fields_group_templates, :appears_on, :text
  end
end
