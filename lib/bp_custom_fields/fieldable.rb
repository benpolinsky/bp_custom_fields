# TODO: BETTER NAME THAN groups (collissions, etc)

module BpCustomFields
  module Fieldable
    def self.included(base)
      base.class_eval do
        has_many :groups, as: :groupable, class_name: "BpCustomFields::Group"
        accepts_nested_attributes_for :groups, reject_if: :all_blank
      end
    end
    
    def add_custom_field_groups
      BpCustomFields::FieldManager.update_groups_for_fieldable(self)
    end
  end
end