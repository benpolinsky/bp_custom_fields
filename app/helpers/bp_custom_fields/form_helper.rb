# Add a FormHelper to fetch and display our custom fields
# There's the possibility there's too much going on in the fetch dept.
# But then I'd have to ask the end user to setup something in controllers (probably)
# 
# usage:
# 
# form_for(@object) do |f|
#   f.bp_custom_fields
# end


module BpCustomFields
  module FormHelper
    
    ActionView::Helpers::FormBuilder.class_eval do
      include ActionView::Context
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::TagHelper
      include BpCustomFields::FieldTypeHelper

      def bp_custom_fields        
        @object.update_custom_field_groups
        if @object.groups.any?
          content_tag :div, class: "custom-field-container bpcf-base-theme" do
            concat content_tag(:div, custom_groups, class: "custom-groups")
          end
        end
      end

      
      private
      
      # hmm.. why isn't this fields?
      # and I am not using this...
      # FOR DELETION
      # def groups
      #   @object.groups.map(&:fields)
      # end
      
      # Setup each custom field's group
      def custom_groups
        fields_for :groups do |group_builder|
          custom_group(group_builder)
        end
      end
      
      # Set up each groups display
      # A Label, a hidden_field to keep track of the group_template_id
      # and of course the custom fields themselves
      def custom_group(group_builder)
        content_tag :div, class: "custom-group" do
          concat content_tag(:p, "#{group_builder.object.name}", class: 'toggle-group active')
          concat content_tag(:span, group_builder.hidden_field(:group_template_id))
          concat content_tag(:div, custom_fields(group_builder), class: "custom-group-inner active")
        end
      end
      
      # Iterate through the builder's fields
      def custom_fields(group_builder)
        group_builder.fields_for :fields do |fields_f|
          capture do
            concat custom_field(fields_f)
          end
        end
      end
       
      # Build the form field from the object's field_template
      def custom_field(field_builder)
        field_template = field_builder.object.field_template
        basic_field(field_builder, field_template)
      end
      
    end
  end
end