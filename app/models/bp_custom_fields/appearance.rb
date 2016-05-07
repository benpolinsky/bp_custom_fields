module BpCustomFields
  class Appearance < ActiveRecord::Base
    belongs_to :group_template
    
    def appears_on
      resource_model = resource.constantize
      if resource_id.nil?
        location = resource_model.all
        location.size == 1 ? location[0] : location
      else
        appears ? resource_model.where(id: resource_id) : resource_model.where.not(id: resource_id)
      end
    end
    
    
    # TODO: A good idea to write these as queries rather than reduce or uniq
    # I'll performance test it...
    # I'm also not confident in this logic...
    def self.appears_on
      location = all.map(&:appears_on)
      location = if location.uniq.size > 1
        location.group_by(&:class).map{ |loc| loc[1].reduce(:&) }.flatten
      else
        location.uniq
      end
      location.size == 1 ? location[0] : location
    end
  end
end
