class CreateBpCustomFieldsGroups < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_groups do |t|
      t.group_template :references

      t.timestamps null: false
    end
  end
end
