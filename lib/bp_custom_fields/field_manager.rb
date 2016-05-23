module BpCustomFields
  module FieldManager    
  
    def self.initialize_group_with_fields(group_template, initial=false)
      group = BpCustomFields::Group.new(group_template: group_template)
      group_template.field_templates.each do |field_template|
        field = group.fields.build(field_template: field_template)
        initialize_field(field, initial)
      end
      group
    end
    
    def self.initialize_field(field, initial=false)
      case field.field_template.field_type
      when "gallery"
        initialize_gallery(field)
      when "repeater"
        initialize_repeater(field)
      when "tab"
        initialize_tab(field)
      when "flexible_content"
        initialize_flexible_content(field, initial)
      end
    end
    
    def self.initialize_gallery(field)
      field.field_template.children.create(field_type: 'image', name: "gallery image")
    end
    
    def self.initialize_repeater(field)
      container_field = field.children.build(container: true)
      container_field.initialize_with_repeater_fields(field)
    end
    
    def self.initialize_tab(field)
      field.field_template.children.each do |child_template|
        initialize_field(field.children.build(field_template: child_template))
      end
    end
    
    def self.initialize_flexible_content(field, initial=false)
      field.field_template.children.each do |layout_template|
        child_field = field.children.build(field_template: layout_template)
        if initial == true
          layout_template.children.each do |layout_child_template|
            layout_child_field = child_field.children.build(field_template: layout_child_template)
            initialize_field(layout_child_field)
          end
        end
      end 
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