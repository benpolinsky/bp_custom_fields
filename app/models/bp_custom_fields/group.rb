module BpCustomFields
  class Group < ActiveRecord::Base
    has_many :fields
    belongs_to :group_template
  end
end
