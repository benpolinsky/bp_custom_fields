module BpCustomFields
  module FieldsHelper
    def bpcf_html_options(field_template, object, options={})
      html_options = {}
      html_options[:class] = "form-control #{options[:class]}" 
      html_options[:placeholder] = field_template.placeholder_text if field_template.placeholder_text.present? && object.value.blank?
      html_options[:value] = field_template.default_value if field_template.default_value.present? && object.value.blank?
      html_options[:required] = field_template.required
      html_options[:minlength] = field_template.min if field_template.min.present?
      html_options[:maxlength] = field_template.max if field_template.max.present?
      html_options[:min] = field_template.min if field_template.min.present?
      html_options[:max] = field_template.max if field_template.max.present?
      html_options[:data] = options[:data] if options[:data]
      html_options
    end
  end
end