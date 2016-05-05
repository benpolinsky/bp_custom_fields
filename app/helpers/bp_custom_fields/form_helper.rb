module BpCustomFields
  module FormHelper
    
    def bp_custom_field_params
      {groups_attributes: [:id, fields_attributes: [:id, :value]]}
    end
    
    ActionView::Helpers::FormBuilder.class_eval do
      include ActionView::Context
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::TagHelper

      def bp_custom_fields
        @object.add_custom_field_groups if @object.groups.none?
        if @object.groups.any?
          content_tag :div, class: "custom-field-container" do
            groups.each do |group|
              concat content_tag :div, custom_fields_for(group), class: "custom-groups"
            end
          end
        end
      end
      
      private
      
      def groups
        @object.groups.map(&:fields)
      end 
      
      def custom_fields_for(group)
        fields_for :groups do |group_f|
          content_tag :div, class: "custom-group" do
            concat content_tag(:span, group_f.hidden_field(:group_template_id))
            concat content_tag(:span, custom_real_fields(group_f))
          end
        end
      end
       
      def custom_field(field_builder)
        field_template = field_builder.object.field_template
        @template.render partial: "bp_custom_fields/field_types/admin/#{field_template.field_type}", 
        locals: {builder: field_builder, field_template: field_template}
      end
      
      def custom_real_fields(group_f)
        group_f.fields_for :fields do |fields_f|
          capture do
            concat custom_field(fields_f)
          end
        end
      end
    end
  end
end