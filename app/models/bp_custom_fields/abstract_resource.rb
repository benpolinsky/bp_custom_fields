module BpCustomFields
  class AbstractResource < ActiveRecord::Base
    include BpCustomFields::Fieldable
    
    
    def self.find_and_create_from_appearances
      appearances = []
      BpCustomFields::Appearance.abstract.each do |appearance|
        appearances << find_or_create_by(name: appearance.resource_id)
      end
      appearances
    end
  end
end
