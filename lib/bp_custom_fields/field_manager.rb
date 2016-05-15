module BpCustomFields
  module FieldManager    
    def self.initialize_group_with_fields(group_template)
      group = BpCustomFields::Group.new(group_template: group_template)
      group_template.field_templates.each do |field_template|
        if field_template.field_type == "gallery"
          # with a gallery, we don't have a child template
          field_template.children.create(field_type: 'image', name: "gallery image")

          # let's build the gallery field
          group.fields.build(field_template: field_template)

        elsif field_template.field_type == "repeater"
          # let's build the repeater field
          field = group.fields.build(field_template: field_template)
          
          # our first repeater group
          repeater_group = field.repeater_groups.build
          # will build each field our repeater field template specifies
          repeater_group.initialize_with_repeater_fields(field)
        else
          group.fields.build(field_template: field_template)
        end
      end
      group
    end
    
    def self.update_groups_for_fieldable(resource)
      found_templates = if resource.new_record?
        BpCustomFields::GroupTemplate.includes(:appearances).
        where("bp_custom_fields_appearances.resource = ? AND (bp_custom_fields_appearances.resource_id IS NULL)", resource.class).references(:bp_custom_fields_appearances)
      else
        BpCustomFields::GroupTemplate.includes(:appearances).
        where("bp_custom_fields_appearances.resource = ? AND (bp_custom_fields_appearances.resource_id IS NULL OR bp_custom_fields_appearances.resource_id = ?)", resource.class, resource.id).references(:bp_custom_fields_appearances)
      end
      
      found_templates = found_templates.reject do |template|
        template.appearances.any?(&:excluded)
      end
      
      resource.groups << found_templates.map {|t| initialize_group_with_fields(t) } 
    end
    

    def self.update_existing_models
      target_model = appearances.first.resource.safe_constantize
      if target_model && target_model.all.any?
        target_model.all.each do |tm|
          BpCustomFields::FieldManager.initialize_group_with_fields(self)
        end
      end
    end
  end
end