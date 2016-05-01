class CreateBpCustomFieldsGroups < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_groups do |t|
      t.string :name
      t.string :location
      t.boolean :visible

      t.timestamps null: false
    end
  end
end
