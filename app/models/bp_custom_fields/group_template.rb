module BpCustomFields
  class GroupTemplate < ActiveRecord::Base
    has_many :field_templates
    has_many :groups, dependent: :destroy
    has_many :appearances
    
    accepts_nested_attributes_for :field_templates, reject_if: :all_blank_except_required, allow_destroy: true
    accepts_nested_attributes_for :appearances, reject_if: :all_blank, allow_destroy: true

    validates :name, presence: true
    validates :appearances, presence: true
    
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
    
    def self.find_for_resource(resource)
      Appearance.where(resource: "Post").map(&:group_template).compact.uniq
      # having trouble getting a nested query to work so we'll use the less efficient above query for now...
      
      #joins(:appearances).where("appearances.resource = ?", resource.class.name)
    end
    
    def update_and_reload(params)
      if update(params)
        groups.each do |group| 
          if group.fields.size != params["field_templates_attributes"].size
            group.update_fields!
          end
        end
      else
        false
      end
    end
  end
end
