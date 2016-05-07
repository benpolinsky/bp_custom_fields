class CreateBpCustomFieldsGroupTemplates < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_group_templates do |t|
      t.string :name
      t.boolean :visible
      
      t.timestamps null: false
    end
  end
end
