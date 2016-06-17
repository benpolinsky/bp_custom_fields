class CreateBpCustomFieldsGroups < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_groups do |t|
      t.references :bp_custom_fields_group_template
      t.timestamps null: false
    end
  end
end
