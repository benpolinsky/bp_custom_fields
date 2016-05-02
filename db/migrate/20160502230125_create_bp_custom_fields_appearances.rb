class CreateBpCustomFieldsAppearances < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_appearances do |t|
      t.string :resource
      t.integer :resource_id
      t.boolean :appears
      t.integer :row_order

      t.timestamps null: false
    end
  end
end
