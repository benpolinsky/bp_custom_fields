module BpCustomFields
  module DisplayHelper
    
    def display_bp_custom_fields
      content_tag :div, class: "custom-fields", data: {action: request[:action]} do
        @custom_field_group_templates.each do |cfg|
          display_custom_field(cfg)
        end
      end
    end
  
    def display_custom_field(field_group_template)
      field_group_template.field_templates.each do |custom_field_template|
        concat content_tag :div, custom_field_template.field_type
        concat content_tag :div, custom_field_template.instructions
        concat custom_field_form(custom_field_template)
      end
    end
  
    def custom_field_form(custom_field_template)
      render partial: "bp_custom_fields/field_types/admin/#{custom_field_template.field_type}", locals: {custom_field_template: custom_field_template}
    end
    
    def find_custom_fields
      @custom_field_group_templates = BpCustomFields::GroupTemplate.find_for_location(request)
    end
  end
  
end