module BpCustomFields
  module Fieldable
    def self.included(base)
      base.class_eval do
        has_many :groups, as: :groupable, class_name: "BpCustomFields::Group"
        after_initialize :add_custom_field_groups
      end
    end
    
    def add_custom_field_groups
      found_templates = BpCustomFields::GroupTemplate.where(appears_on: self.class)
      self.groups << found_templates.map {|t| t.groups.new}
    end
  end
end