class CreateBpCustomFieldsAbstractResources < ActiveRecord::Migration
  def change
    create_table :bp_custom_fields_abstract_resources do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
