module BpCustomFields
  class Field < ActiveRecord::Base
    belongs_to :field_template
    belongs_to :group
    
    delegate :name, :label, :field_type, :min, :max, :instructions, :default_value, :placeholder_text, :prepend, to: :field_template      
    mount_uploader :file, BasicUploader
    attr_accessor :is_image
  end
end
