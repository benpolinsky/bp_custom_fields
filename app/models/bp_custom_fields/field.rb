module BpCustomFields
  class Field < ActiveRecord::Base

    # the field_type determines:
    # How the value is entered by the user,
    # Which values are allowed/validated (customvalidator),
    # How the value is displayed to the user in the admin section
    # And how it is displayed on the front end
    enum field_types: [:string, :text, :number, :email, :editor, :date, :image, :video, :audio]
    
    belongs_to :group
    validates_with BpCustomFields::FieldValidator
    
    serialize :options, JSON
    
    def self.pretty_field_types
      self.field_types.keys.map(&:titleize)
    end
  end
end
