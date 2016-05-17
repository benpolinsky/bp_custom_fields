module BpCustomFields
  class Group < ActiveRecord::Base
    attr_accessor :is_sub_group
    
    has_many :fields, dependent: :destroy
    belongs_to :parent_field, class_name: "BpCustomFields::Field"
    
    belongs_to :group_template
    belongs_to :groupable, polymorphic: true
    
    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
    validates :group_template, presence: true, unless: Proc.new { |g| g.is_sub_group }
    
    delegate :name, to: :group_template
    
    def update_available?
      fields.size != group_template.field_templates.size
    end
    
    def update_fields!
      if update_available?
        current_field_template_ids = fields.map(&:field_template_id)
        field_template_ids_to_add = group_template.field_templates.map(&:id) - current_field_template_ids
        field_template_ids_to_add.each do |ft|
          fields.create(field_template_id: ft)
        end
      else
        false
      end
    end
    
    # right now I'm only using this in testing, but I do think it could come in handy.
    # the actual method I'm using is in FieldManager
    def create_fields_from_templates
      save
      group_template.field_templates.each do |ft|
        fields.create(field_template: ft)
      end
    end
    
    def initialize_with_repeater_fields(repeater)
      repeater.field_template.children.each do |child_template|
        if child_template.field_type == "gallery"
          child_template.children.create(field_type: 'image', name: "gallery image")
        end
        fields.build(field_template: child_template)

      end
      self
    end
    
  end
end
