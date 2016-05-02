module BpCustomFields
  module DisplayHelper
    def display_bp_custom_fields
      content_tag :div, class: "custom-fields", data: {action: request[:action]} do
        @custom_field_groups.each do |cfg|
          display_custom_field(cfg)
        end
      end
    end
  
    def display_custom_field(field_group)
      field_group.fields.each do |custom_field|
        concat content_tag :div, custom_field.field_type
        concat content_tag :div, custom_field.instructions
        concat custom_field_form(custom_field)
      end
    end
  
    def custom_field_form(custom_field)
      render partial: "bp_custom_fields/field_types/admin/#{custom_field.field_type}", locals: {custom_field: custom_field}
    end
    
    def find_custom_fields
      @custom_field_groups = BpCustomFields::Group.find_for_location(request)
    end
  end
  
end