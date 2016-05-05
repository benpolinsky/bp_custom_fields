class CreateBpCustomFieldsAppearances < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_appearances do |t|
      t.string :resource
      t.integer :resource_id
      t.boolean :appears, default: true
      t.integer :row_order
      t.references :group_template, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
