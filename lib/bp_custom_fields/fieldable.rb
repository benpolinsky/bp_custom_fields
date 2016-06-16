# TODO: BETTER NAME THAN groups (collissions, etc)

module BpCustomFields
  module Fieldable
    def self.included(base)
      base.class_eval do

        has_many :groups, as: :groupable, class_name: "BpCustomFields::Group"
        accepts_nested_attributes_for :groups, reject_if: :all_blank

        def self.find_fields(params)
          if params.respond_to?(:keys)
            BpCustomFields::Field.joins(:field_template, :group => [:group_template => :appearances]).
            where(bp_custom_fields_group_templates: {name: params[:group]}, bp_custom_fields_field_templates: {name: params[:field]}, bp_custom_fields_appearances: {resource: self.name})
          else
            BpCustomFields::Field.joins(:field_template, :group => [:group_template => :appearances]).
            where(bp_custom_fields_field_templates: {name: params}, bp_custom_fields_appearances: {resource: self.name})
          end
        end
        
        def self.find_groups(group_name)
          BpCustomFields::Group.joins(:group_template => :appearances).
          where(bp_custom_fields_group_templates: {name: group_name}, bp_custom_fields_appearances: {resource: self.name})
        end
      end
    end
        
    def update_custom_field_groups
      if groups.none?
        add_custom_field_groups
      else
        add_new_custom_field_groups if new_groups_available?
        delete_stale_groups if stale_groups?
      end
    end

    def add_custom_field_groups
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
    
    def group_templates
      GroupTemplate.find_for_resource(self).flatten
    end
    
    def custom_fields
      groups.flat_map(&:fields)
    end
    
    def groups_and_fields
      groups.map do |group|
        {group.name => group.fields}
      end
    end
    
    def id_or_name
      self.try(:name) ? name.downcase : id
    end
    
    def find_fields(params)
      if params.respond_to?(:keys)
        BpCustomFields::Field.joins(:field_template, :group => [:group_template => :appearances]).
        where(bp_custom_fields_group_templates: {name: params[:group]}, bp_custom_fields_field_templates: {name: params[:field]}, bp_custom_fields_appearances: {resource: self.class.name, resource_id: self.id})
      else
        BpCustomFields::Field.joins(:field_template, :group => [:group_template => :appearances]).
        where(bp_custom_fields_field_templates: {name: params}, bp_custom_fields_appearances: {resource: self.class.name, resource_id: self.id})
      end
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
    
  end
end