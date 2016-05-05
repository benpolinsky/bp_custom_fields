module BpCustomFields
  class Group < ActiveRecord::Base
    has_many :fields
    belongs_to :group_template
    belongs_to :groupable, polymorphic: true
    
    accepts_nested_attributes_for :fields, reject_if: :all_blank, allow_destroy: true
    validates_presence_of :group_template
    
    def create_fields_from_templates
      save
      group_template.field_templates.each do |ft|
        fields.create(field_template: ft)
      end
    end
  end
end
