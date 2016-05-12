module BpCustomFields
  class Field < ActiveRecord::Base
    belongs_to :field_template
    belongs_to :group
    
    delegate :name, :label, :field_type, :min, :max, :instructions, :default_value, :placeholder_text, :prepend, to: :field_template      
    mount_uploader :file, BasicUploader
    attr_accessor :is_image
    
    
    def display
      case 
      when field_type == "number"
        to_smart_number
      when self.fileable?
        file.url
      else
        value
      end
    end
    
    # think about different ways to refactor field_type-specific methods
    # once you flesh them all out: STI, etc..s
    
    # file / image methods
    def absolute_url
      return unless fileable?
      Rails.application.routes.default_url_options[:host] ||= "http://localhost:3000"
      Rails.application.routes.url_helpers.root_url[0..-2] + file.url
    end


    def fileable?
      self.class.fileable_types.include? field_type
    end
    
    def dateable?
      self.class.dateable_types.include? field_type
    end
    
    def self.fileable_types
      ['image', 'video', 'file', 'audio']
    end

    def self.dateable_types
      ['date', 'datetime', 'time']
    end  
    
    private
    # Thanks to @jaredonline: http://stackoverflow.com/a/8072164/791026    
    def to_smart_number
      ((float = Float(value)) && (float % 1.0 == 0) ? float.to_i : float) rescue value
    end
  end
end
