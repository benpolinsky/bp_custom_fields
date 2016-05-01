module BpCustomFields
  class FieldValidator < ActiveModel::Validator
    
    def validate(record)
      # case record.field_type
      # when :file
      #   record.errors[:base] << "No file uploaded" if record.file.blank?
      # else
      #   record.errors[:value] << "Please enter a value" if record.value.blank?
      # end
    end
  end
end