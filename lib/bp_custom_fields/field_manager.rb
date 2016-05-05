module BpCustomFields
  class FieldManager
    def initialize
    end
    
    def initialize_group_with_fields(group_template)
      group = BpCustomFields::Group.new(group_template: group_template)
      group_template.field_templates.each do |ft|
        group.fields.build(field_template: ft)
      end
      group
    end
    
    def create_groups_and_fields_for_fieldable
      
    end
    
    def update_groups_for_fieldable(resource)
      found_templates = BpCustomFields::GroupTemplate.includes(:appearances).
      where("bp_custom_fields_appearances.resource = ?", resource.class).references(:bp_custom_fields_appearances)
      resource.groups << found_templates.map {|t| initialize_group_with_fields(t) } 
    end
    
    private
    
    
  end
end