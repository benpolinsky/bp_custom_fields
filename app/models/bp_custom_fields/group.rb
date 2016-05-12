module BpCustomFields
  class Group < ActiveRecord::Base
    has_many :fields, dependent: :destroy
    belongs_to :group_template
    belongs_to :groupable, polymorphic: true
    
    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
    validates_presence_of :group_template
    
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
    
  end
end
