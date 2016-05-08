module BpCustomFields
  module FieldsHelper
    def custom_fields_html_options(field_template, extra_classes='')
      html_options = {}
      html_options[:class] = "form-control #{extra_classes}"
      html_options[:placeholder] = field_template.placeholder_text if field_template.placeholder_text.present?
      html_options[:value] = field_template.default_value if field_template.default_value.present?
      html_options[:required] = field_template.required
      html_options[:minlength] = field_template.min if field_template.min.present?
      html_options[:maxlength] = field_template.max if field_template.max.present?
      html_options[:min] = field_template.min if field_template.min.present?
      html_options[:max] = field_template.max if field_template.max.present?
      html_options
    end
  end
end