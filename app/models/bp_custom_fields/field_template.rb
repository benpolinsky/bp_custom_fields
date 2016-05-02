module BpCustomFields
  class FieldTemplate < ActiveRecord::Base

    # the field_type determines:
    # How the value is entered by the user,
    # Which values are allowed/validated (customvalidator),
    # How the value is displayed to the user in the admin section
    # And how it is displayed on the front end
    enum field_type: [:string, :text, :number, :email, :editor, :date, :image, :video, :audio]
    
    belongs_to :group_template
    has_many :fields
    
    validates :name, presence: true
    
    serialize :options, JSON
    
    def self.pretty_field_types
      self.field_types.keys.map(&:titleize)
    end
    
    def id_for_input
      "custom_field_group_templates[#{group_template.id}][#{id}]"
    end
  end
end
