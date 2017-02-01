# These are helper methods for displaying custom fields.
# These are not helper methods for displaying custom field_templates

module BpCustomFields
  module FieldTypeHelper
    include ActionView::Helpers::TextHelper
    include ActionView::Helpers::TagHelper
    
    def basic_field(f, field_template)
      content_tag :div, class: "custom-field form-group #{field_template.field_type} #{field_template.name.downcase.underscore}" do
        concat f.hidden_field :field_template_id
        concat f.label :value, field_template.label.upcase.titleize, class: "form-label" 
        concat content_tag(:div, field_template.instructions, class: "field-instructions") unless field_template.instructions.blank? 
        concat content_tag(:div, field_template.prepend, class: "bpcf-prepend") unless field_template.prepend.blank? 
        concat ApplicationController.new.render_to_string partial: "bp_custom_fields/field_types/admin/#{field_template.field_type}",
                    locals: {builder: f, field_template: field_template}
        concat content_tag(:div, field_template.append, class: "bpcf-prepend") unless field_template.append.blank?
      end
    end
    
    
    def bpcf_string_field(builder, field_template)
      builder.text_field :value, bpcf_html_options(field_template, builder.object)
    end
    
    def bpcf_email_field(builder, field_template)
      builder.email_field :value, bpcf_html_options(field_template, builder.object)
    end
    
    def bpcf_number_field(builder, field_template)
      builder.number_field :value, bpcf_html_options(field_template, builder.object)
    end
    
    # TODO: refactor
    def bpcf_checkbox_field(f, field_template)
      if field_template.multiple
        if field_template.all_choices.respond_to?(:keys)
          field_template.all_choices.each do |key, value|
            concat content_tag :span, key
            concat f.check_box :value, {multiple: true, checked: "#{'checked' if builder.object.value.try(:include?, value)}"}, value
          end
        else
          field_template.all_choices.each do |choice|
            concat content_tag :span, choice
            concat f.check_box :value, {multiple: true, checked: "#{'checked' if builder.object.value.try(:include?, choice)}"}, choice
          end
        end
      else
        if field_template.all_choices.respond_to?(:keys)
          field_template.all_choices.each do |key, value|
            concat f.label "value", key
            concat f.radio_button "value", key
          end
        else
          field_template.all_choices.each do |choice|
            concat f.label "value", choice
            concat f.radio_button "value", choice
          end
        end
      end
    end
    
    def bpcf_date_and_time_field(builder, field_template)
      builder.text_field :value, bpcf_html_options(field_template, builder.object, {class: "bp-date-field", data: {enabletime: true, timeFormat: "#{field_template.time_format}", dateFormat: "#{field_template.date_format}"}})
    end
    
    def bpcf_date_field(builder, field_template)
      builder.text_field :value, bpcf_html_options(field_template, builder.object, {class: "bp-date-field", data: {dateformat: "#{field_template.date_format}"}})
    end
    
    def bpcf_time_field(builder, field_template)
      builder.text_field :value, bpcf_html_options(field_template, builder.object, {class: "bp-date-field", data: {enabletime: true, nocalendar: true, timeformat: "#{field_template.time_format}"}})
    end

    def bpcf_select_field(builder, field_template)
      builder.select :value, options_for_select(field_template.all_choices, builder.object.to_a), 
          bpcf_html_options(field_template, builder.object), bpcf_html_other_options(field_template)
    end

    def bpcf_text_field(builder, field_template)
      builder.text_area :value, bpcf_html_options(field_template, builder.object, {class: "form-control"})
    end
    
    def bpcf_editor_field(builder, field_template)
      builder.text_area :value, bpcf_html_options(field_template, builder.object, {class: "bpcf-editor", data: {'toolbar-state' => field_template.toolbar}})
    end
    
    
    def bpcf_file_field(builder, field_template)
      capture do
        if builder.object.file.present?
          concat content_tag :p, 'Current File: '
          concat link_to(builder.object.file.url)
          concat content_tag :p, 'Replace: '
        else
          concat content_tag :p, 'Upload a File'
        end
        concat builder.file_field :file, bpcf_html_options(field_template, builder.object, {accept: field_template.accepted_file_types})
      end
    end
    
    def bpcf_image_field(builder, field_template)
      capture do
        if builder.object.file.present?
          concat content_tag :p, 'Current Image: '
          concat image_tag builder.object.file
          concat content_tag :p, 'Replace: '
        else
          concat content_tag :p, 'Upload an Image: '
        end
        concat builder.file_field :file, bpcf_html_options(field_template, builder.object, {accept: field_template.accepted_file_types})
      end
    end
    
    def bpcf_video_field(builder, field_template)
      capture do
        concat content_tag :p, 'Upload a Video'
        concat builder.text_field :value, bpcf_html_options(field_template, builder.object)
      end

    end
    
    def bpcf_truefalse_field(builder, field_template)
      builder.check_box :value, {checked: "#{builder.object.value == 'true' ? 'checked' : ''}"}, 'true', 'false'
    end

  end  
end


