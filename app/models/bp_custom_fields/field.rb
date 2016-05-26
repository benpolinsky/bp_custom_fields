module BpCustomFields
  class Field < ActiveRecord::Base
    
    include RankedModel
    ranks :row_order
    
    belongs_to :field_template
    belongs_to :group
    # has_many :sub_groups, class_name: "BpCustomFields::Group", foreign_key: "parent_field_id"
  
    has_many :children, class_name: "BpCustomFields::Field", inverse_of: :parent, foreign_key: "parent_id"
    belongs_to :parent, class_name: "BpCustomFields::Field", inverse_of: :children
    
    delegate :name, :label, :field_type, :min, :max, :instructions, :default_value, 
             :placeholder_text, :prepend, :choices, :multiple,
             :fileable?, :dateable?, :chooseable?, :nestable?, to: :field_template
      
    mount_uploader :file, BasicUploader
    attr_accessor :is_image
    
    before_save :set_value_for_multiple

    accepts_nested_attributes_for :children, reject_if: :all_blank, allow_destroy: true
    # accepts_nested_attributes_for :sub_groups, reject_if: :all_blank, allow_destroy: true
    # TODO: value or file needs to be present to be valid
    
    
    
    def container_fields
      children.where(container: true)
    end
    
    def self.only_parents
      where("parent_id IS NULL")
    end
    
    def set_value_for_multiple
      return if container?
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
    
    def initialize_layout(layout)
      self.field_template = layout.field_template
      self.parent = layout.parent
      layout.field_template.children.each do |layout_child_template|
        child_field = self.children.build(field_template: layout_child_template)
        BpCustomFields::FieldManager.initialize_field(child_field)        
      end
      self
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
    
    def initialize_with_repeater_fields(repeater)
      repeater.field_template.children.each do |child_template|
        if child_template.field_type == "gallery"
          child_template.children.create(field_type: 'image', name: "gallery image")
        end
        children.build(field_template: child_template)
      end
      self
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
