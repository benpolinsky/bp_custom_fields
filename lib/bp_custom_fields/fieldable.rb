# TODO: BETTER NAME THAN groups (collissions, etc)

module BpCustomFields
  module Fieldable
    def self.included(base)
      base.class_eval do
        has_many :groups, as: :groupable, class_name: "BpCustomFields::Group"
        accepts_nested_attributes_for :groups, reject_if: :all_blank
      end
    end
    
    def update_custom_field_groups
      if groups.none?
        add_custom_field_groups
      else
        # groups.each(&:update_fields!)
        add_new_custom_field_groups if new_groups_available?
        delete_stale_groups if stale_groups?
      end


    end

    def add_custom_field_groups
      # Consider if the FieldManager is really needed?
      BpCustomFields::FieldManager.update_groups_for_fieldable(self)
    end
    
    def new_groups_available?
      groups.size < GroupTemplate.find_for_resource(self).size
    end
    
    def add_new_custom_field_groups
      new_group_template_ids = actual_group_template_ids - attached_group_template_ids
      new_group_template_ids.each do |group_template_id| 
        group = groups.create(group_template_id: group_template_id)
        group.update_fields!
      end
    end
  
    def stale_groups?
      groups.size > GroupTemplate.find_for_resource(self).size
    end
    
    def delete_stale_groups
      stale_group_template_ids = attached_group_template_ids - actual_group_template_ids
      groups.where(group_template_id: stale_group_template_ids).destroy_all
      reload
    end
    
    
    
    private
    
    def attached_group_template_ids
      groups.map(&:group_template_id)
    end
    
    def actual_group_template_ids
      if group_templates.any?
        group_templates.map(&:id) 
      else
        []
      end
    end
    
    def group_templates
      GroupTemplate.find_for_resource(self).flatten
    end
  end
end