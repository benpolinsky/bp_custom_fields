class CreateBpCustomFieldsFields < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_fields do |t|
      t.integer :field_template_id, foreign_key: true, index: { name: 'bpf_f_ft' }
      t.integer :group_id, foreign_key: true, index: { name: 'bpf_f_g' }
      t.text :value
      t.string :file
      t.integer :parent_id
      t.boolean :container
      t.integer :row_order
      t.timestamps null: false
    end
  end
end
