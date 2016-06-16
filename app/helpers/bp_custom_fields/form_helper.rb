module BpCustomFields
  module FormHelper
    
    ActionView::Helpers::FormBuilder.class_eval do
      include ActionView::Context
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::TagHelper

      def bp_custom_fields        
        @object.update_custom_field_groups
        if @object.groups.any?
          content_tag :div, class: "custom-field-container bpcf-base-theme" do
            concat content_tag(:div, custom_groups, class: "custom-groups")
          end
        end
      end
      
      def bp_custom_abstract_fields
        custom_group(self)
      end
      
      private
      
      def groups
        @object.groups.map(&:fields)
      end 
      
      def custom_groups
        fields_for :groups do |group_builder|
          custom_group(group_builder)
        end
      end
      
      def custom_group(group_builder)
        content_tag :div, class: "custom-group" do
          concat content_tag(:p, "#{group_builder.object.name}", class: 'toggle-group active')
          concat content_tag(:span, group_builder.hidden_field(:group_template_id))
          concat content_tag(:div, custom_fields(group_builder), class: "custom-group-inner active")
        end
      end
      
      def custom_fields(group_builder)
        group_builder.fields_for :fields do |fields_f|
          capture do
            concat custom_field(fields_f)
          end
        end
      end
       
      def custom_field(field_builder)
        field_template = field_builder.object.field_template
        @template.render partial: "bp_custom_fields/field_types/admin/basic", 
        locals: {f: field_builder, field_template: field_template}
      end
      
    end
  end
end