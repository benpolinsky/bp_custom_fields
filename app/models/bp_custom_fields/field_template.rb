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
                      :dropdown, :truefalse, :gallery, :repeater,
                      :tab, :flexible_content, :layout
                      ]
    
    belongs_to :group_template
    has_many :fields, dependent: :destroy
    has_many :children, class_name: "BpCustomFields::FieldTemplate", inverse_of: :parent, foreign_key: "parent_id"
    belongs_to :parent, class_name: "BpCustomFields::FieldTemplate", inverse_of: :children
    
    accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true
    
    
    validates :name, presence: true

    # move these into a validation object
    validate :gallery_children
    validate :flex_children
  
    # TODO: field_type is required
    # TODO: choices is required if type is chooseable


    def all_blank_except(atts)
      atts.except(:required, :field_type, :_destroy).values.all?(&:blank?)
    end
    
    def gallery_children
      errors.add(:field_type, "Children of galleries must be set to images") if parent.try(:field_type) == "gallery" && field_type != 'image'
    end
    
    def flex_children
      errors.add(:field_type, "Children of flexible content must be set to layout") if parent.try(:field_type) == 'flexible_content' && field_type != 'layout'
    end
  
    def all_choices
      array_choices = choices.split(",").map(&:strip)
      if array_choices.all?{|c| c.include?(':')}
        array_choices.inject({}) {|choice_hash, choice| choice_hash[choice.split(':')[0]] = choice.split(':')[1]; choice_hash}
      else
        array_choices
      end
    end
    
    def has_children?
      children.any?(&:persisted?)
    end
    
    def is_root?
      parent.nil?
    end
    
    def initialize_if
      self if number_of_parents(self) < 5
    end
    
    def number_of_parents(ob, num=0)
      if ob.parent.present?
        num += 1
        number_of_parents(ob.parent, num)
      else
        num
      end
    end
    
    def fileable?
      self.class.fileable_types.include? field_type
    end
    
    def dateable?
      self.class.dateable_types.include? field_type
    end
    
    def chooseable?
      self.class.chooseable_types.include? field_type
    end
    
    def nestable?
      self.class.nestable_types.include? field_type
    end
    
    def self.fileable_types
      ['image', 'video', 'file', 'audio']
    end

    def self.dateable_types
      ['date', 'datetime', 'time']
    end  
    
    def self.chooseable_types
      ['dropdown', 'truefalse', 'checkboxes']
    end
    
    def self.nestable_types
      ['gallery']
    end
    
    def self.field_type_options
      BpCustomFields::FieldTemplate.pretty_field_types.zip(BpCustomFields::FieldTemplate.field_types.except(:layout).keys)
    end
    
    def self.repeater_field_type_options
      self.field_type_options - [["Repeater", "repeater"]]
    end
    
    
    def self.tab_field_type_options
      self.field_type_options - [["Repeater", "repeater"], ["Tab", "tab"]]
    end
    
    def self.pretty_field_types
      self.field_types.except(:layout).keys.map(&:titleize)
    end
  end
end
