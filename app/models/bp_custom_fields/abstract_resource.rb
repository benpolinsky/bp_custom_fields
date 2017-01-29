module BpCustomFields
  class AbstractResource < ActiveRecord::Base
    include BpCustomFields::Fieldable
    
    # Not quite sure why #inject over #map..
    # I want an array returned? 
    def self.find_or_create_from_appearances(appearances)
      appearances.inject([]) do |memo, appearance|
        memo << find_or_create_by(name: appearance.resource_id.downcase)
      end
    end
    
  end
end
