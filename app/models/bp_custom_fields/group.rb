module BpCustomFields
  class Group < ActiveRecord::Base
    has_many :fields
    accepts_nested_attributes_for :fields, reject_if: :all_blank_except_required, allow_destroy: true
    
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
  end
end
