module BpCustomFields
  class Field < ActiveRecord::Base
    belongs_to :field_template
    belongs_to :group
    has_many :children, class_name: "BpCustomFields::Field", inverse_of: :parent, foreign_key: "parent_id"
    belongs_to :parent, class_name: "BpCustomFields::Field", inverse_of: :children
    
    delegate :name, :label, :field_type, :min, :max, :instructions, :default_value, 
             :placeholder_text, :prepend, :choices, :multiple,
             :fileable?, :dateable?, :chooseable?, :nestable?, to: :field_template
      
    mount_uploader :file, BasicUploader
    attr_accessor :is_image
    
    before_save :set_value_for_multiple
    accepts_nested_attributes_for :children
    
    # TODO: value or file needs to be present to be valid
    def self.only_parents
      where("parent_id IS NULL")
    end
    
    def set_value_for_multiple
      value = if field_type == 'checkboxes' && multiple && value.present?
        value.compact.reject!{|v| v == "0"}
      else
        value
      end
    end
    
    def display
      case 
      when field_type == "number"
        to_smart_number
      when field_type == 'truefalse'
        to_truefalse
      when self.fileable?
        file.url
      when self.chooseable? && self.multiple
        to_a.join(",")
      else
        value
      end
    end
    
    def to_a
      if multiple && value.present? 
        begin
          JSON.parse(value).reject(&:blank?)          
        rescue JSON::ParserError
          [value]
        end
      elsif nestable?
        children.map(&:absolute_url)
      else
        [value]
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

    def new_gallery_image_id
      parent.field_template.children.first.id
    end
    
    private
    # Thanks to @jaredonline: http://stackoverflow.com/a/8072164/791026    
    def to_smart_number
      ((float = Float(value)) && (float % 1.0 == 0) ? float.to_i : float) rescue value
    end
    
    def to_truefalse
      case value
      when '0', 0, true, 'true'
        'true'
      when '1', 1, false, 'false'
        'false'
      else
        value
      end
    end
  end
end
