module BpCustomFields
  class AbstractResource < ActiveRecord::Base
    include BpCustomFields::Fieldable
    validates_uniqueness_of :name

    
    # Not quite sure why #inject over #map..
    # I want an array returned? 
    def self.find_or_create_from_appearances(appearances)
      appearances.inject([]) do |memo, appearance|
        resource_id = appearance.resource_id
        memo << where('name = ?', resource_id).first_or_create(name: resource_id)
      end
    end
    
  end
end
