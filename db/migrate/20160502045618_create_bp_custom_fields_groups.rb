class CreateBpCustomFieldsGroups < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_groups do |t|
      t.references :group_template
      t.integer   :parent_field_id
      t.timestamps null: false
    end
  end
end
