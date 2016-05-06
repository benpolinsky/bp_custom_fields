module BpCustomFields
  module FieldManager    
    def self.initialize_group_with_fields(group_template)
      group = BpCustomFields::Group.new(group_template: group_template)
      group_template.field_templates.each do |ft|
        group.fields.build(field_template: ft)
      end
      group
    end
    
    def self.update_groups_for_fieldable(resource)
      found_templates = BpCustomFields::GroupTemplate.includes(:appearances).
      where("bp_custom_fields_appearances.resource = ?", resource.class).references(:bp_custom_fields_appearances)
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