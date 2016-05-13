module BpCustomFields
  class FieldTemplate < ActiveRecord::Base

    # the field_type determines:
    # How the value is entered by the user,
    # Which values are allowed/validated (customvalidator),
    # How the value is displayed to the user in the admin section
    # And how it is displayed on the front end
    enum field_type: [
                      :string, :text, :number, :email, :editor, 
                      :date_and_time, :date, :time, :file, 
                      :image, :video, :audio, :checkboxes, 
                      :dropdown, :truefalse 
                      ]
    
    belongs_to :group_template
    has_many :fields, dependent: :destroy
    validates :name, presence: true
    # TODO: field_type is required
    # TODO: choices is required if type is chooseable

  
    
    def self.pretty_field_types
      self.field_types.keys.map(&:titleize)
    end

    def all_choices
      array_choices = choices.split(",").map(&:strip)
      if array_choices.all?{|c| c.include?(':')}
        array_choices.inject({}) {|choice_hash, choice| choice_hash[choice.split(':')[0]] = choice.split(':')[1]; choice_hash}
      else
        array_choices
      end
    end
    

  end
end
