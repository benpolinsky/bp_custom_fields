module BpCustomFields
  class GroupTemplate < ActiveRecord::Base
    has_many :field_templates
    has_many :groups, dependent: :destroy
    has_many :appearances
    
    accepts_nested_attributes_for :field_templates, reject_if: :all_blank_except_required, allow_destroy: true
    accepts_nested_attributes_for :appearances, reject_if: :all_blank, allow_destroy: true

    validates :name, presence: true
    validates :appearances, presence: true
    
    
    def appears_on
      appearances.appears_on
    end
    
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
    
    def self.find_for_resource(resource)
      Appearance.where(resource: resource.class.name).map(&:group_template).compact.uniq
      # having trouble getting a nested query to work so we'll use the less efficient above query for now...
      
      #joins(:appearances).where("appearances.resource = ?", resource.class.name)
    end
    
    def reload_fields
      groups.each {|group| group.update_fields! if group.fields.size != field_templates.size}
    end
    
    def update_and_reload_fields(params)
      # not the way to go.. if bp_display_custom_fields handles everything else
      if update(params)
        reload_fields
      else
        false
      end
    end
  end
end
