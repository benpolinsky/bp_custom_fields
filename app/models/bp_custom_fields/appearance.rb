module BpCustomFields
  class Appearance < ActiveRecord::Base
    belongs_to :group_template
    validate :abstract_appearance_requires_id
    
    
    def full_collection?(resource_class_name)
      resource_id.nil? && resource == resource_class_name
    end
    
    def appears_on
      if resource_id.nil?
        find_all_resources
      else
        find_all_resources_with_conditions
      end
    end
    
    def excluded
      !appears
    end
    
    def abstract?
      resource == "BpCustomFields::AbstractResource"
    end
    
    def abstract_appearance_requires_id
      errors.add(:base, "Abstract Appearance requires a name") if abstract? && resource_id.blank?
    end
    
    def self.full_collection?(resource_class_name)
      where(resource: resource_class_name, resource_id: nil).count > 0
    end
    
    
    # TODO: A good idea to write these as queries rather than reduce or uniq
    # I'll performance test it...
    # I'm also not completely confident in this logic...
    def self.appears_on
      location = all.map(&:appears_on)
      location = if location.uniq.size > 1
        location.group_by(&:class).map{ |loc| loc[1].reduce(:&) }.flatten
      else
        location.uniq
      end
      location.size == 1 ? location[0] : location
    end
    
    def self.abstract
      where(resource: "BpCustomFields::AbstractResource")
    end
    private
    
    def resource_model
      resource.safe_constantize
    end
    
    def find_all_resources
      location = resource_model.all
      location.size == 1 ? location[0] : location
    end
    
    def find_all_resources_with_conditions
      if abstract?
        "#{resource}: #{resource_id}"
      else
        appears ? resource_model.where(id: resource_id) : resource_model.where.not(id: resource_id)
      end
    end
  end
end
