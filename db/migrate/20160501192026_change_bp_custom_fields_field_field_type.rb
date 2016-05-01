class ChangeBpCustomFieldsFieldFieldType < ActiveRecord::Migration
  def change
    change_column_default :bp_custom_fields_fields, :field_type, nil
  end
end
