module BpCustomFields
  class AbstractResource < ActiveRecord::Base
    include BpCustomFields::Fieldable
    
    def self.find_or_create_from_appearances(appearances)
      appearances.inject([]) do |memo, appearance|
        memo << find_or_create_by(name: appearance.resource_id)
      end
    end
    
  end
end
