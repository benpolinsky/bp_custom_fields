# TODO: BETTER NAME THAN groups (collissions, etc)

module BpCustomFields
  module Fieldable
    def self.included(base)
      base.class_eval do
        has_many :groups, as: :groupable, class_name: "BpCustomFields::Group"
        after_initialize :add_custom_field_groups
        accepts_nested_attributes_for :groups, reject_if: :all_blank
      end
    end
    
    def add_custom_field_groups
      found_templates = BpCustomFields::GroupTemplate.includes(:appearances).
      where("bp_custom_fields_appearances.resource = ?", self.class).references(:bp_custom_fields_appearances)

      # we need to check if it is a new record, because we don't want to add groups twice
      self.groups << found_templates.map {|t| t.groups.new} # if self.new_record?
      self.groups.each(&:create_fields_from_templates)
    end
  end
end