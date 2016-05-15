module BpCustomFields
  module FieldsHelper
    def bpcf_html_options(field_template, object, options={})
      html_options = {}
      html_options[:class] = "form-control #{options[:class]}" 
      html_options[:placeholder] = field_template.placeholder_text if field_template.placeholder_text.present? && object.value.blank?
      html_options[:value] = field_value(field_template, object, options)
      html_options[:required] = field_template.required
      html_options[:minlength] = field_template.min if field_template.min.present?
      html_options[:maxlength] = field_template.max if field_template.max.present?
      html_options[:min] = field_template.min if field_template.min.present?
      html_options[:max] = field_template.max if field_template.max.present?
      html_options[:data] = options[:data] if options[:data]
      html_options[:accept] = field_template.accepted_file_types if field_template.accepted_file_types.present?
      html_options[:rows] = field_template.rows if field_template.rows.present?
     # html_options[:multiple] = field_template.multiple if field_template.multiple
      #html_options[:toolbar] = field_template.toolbar if field_template.toolbar.present?
      html_options[:selected] = 'selected' if object.value == "true"
      html_options
    end
    
    def bpcf_html_other_options(field_template)
      html_options = {}
      html_options[:multiple] = true if field_template.multiple?
      html_options
    end
    
    def toolbar_select_default(f)
      f.object.toolbar.present? ? f.object.toolbar : "Full" 
    end
    
    private
    def field_value(template, object, options)
      if object.value.present?
        object.value
      elsif template.default_value.present?
        template.default_value
      elsif options[:value].present?
        options[:value]
      else
        nil
      end
    end
  end
end