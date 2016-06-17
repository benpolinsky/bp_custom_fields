class CreateBpCustomFieldsAppearances < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_appearances do |t|
      t.string :resource
      t.string :resource_id
      t.boolean :appears, default: true
      t.integer :row_order
      t.integer :group_template_id, foreign_key: true, index: { name: 'bpf_a_gt' }

      t.timestamps null: false
    end
  end
end
