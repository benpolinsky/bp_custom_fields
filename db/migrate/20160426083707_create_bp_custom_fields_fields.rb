class CreateBpCustomFieldsFields < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_fields do |t|
      t.string :label
      t.text :value
      t.references :group, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
