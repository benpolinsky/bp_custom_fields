module BpCustomFields
  module ParameterHelper
    def bpcf_group_template_permitted_params(params)
      node_attributes_base = [:_destroy, :field_type, :required, :min, :max, :prepend, :append, :required, :default_value, 
          :instructions, :label, :placeholder_text, :id, :name, :rows, :accepted_file_types, :toolbar, 
          :date_format, :time_format, :choices, :multiple, :parent_id, :row_order]
      nodes = []
      if params.present?
        params.values.each do |inner_params|
          (1..count_levels(inner_params, :children_attributes)).each do |val|
            nodes = node_attributes_base + [children_attributes: nodes]
          end
        end
      end
      nodes
    end
  
    def bpcf_fieldable_permitted_params(params)
      node_attributes_base = [:id, :container, :value, :file, :field_template_id, :group_id, :parent_id, :_destroy, value: []]
      nodes = []
      children_attributes = deep_find(params)
    
      if params.present? && children_attributes
        children_attributes.values.map{|v| v["fields_attributes"].values}.flatten.each do |inner_params|
          (1..count_levels(inner_params, :children_attributes)).each do |val|
            nodes = node_attributes_base + [children_attributes: nodes]
          end
        end
      end
    
      {
        groups_attributes: [
          :id, :group_template_id, :_destroy, fields_attributes: [
            :id, :value, :file, :field_template_id, :group_id, :_destroy, value: [], children_attributes: nodes
          ]
        ]
      }
    end
  
    def bpcf_fieldable_permitted_group_params(params)
      node_attributes_base = [:id, :container, :value, :file, :field_template_id, :parent_id, :_destroy, value: []]
      nodes = []
      children_attributes = deep_find(params)
    
      if params.present? && children_attributes
        children_attributes.values.map{|v| v["fields_attributes"].values}.flatten.each do |inner_params|
          (1..count_levels(inner_params, :children_attributes)).each do |val|
            nodes = node_attributes_base + [children_attributes: nodes]
          end
        end
      end
    
    
        [:abstract_appearance_resource_id, :id, :group_template_id, :_destroy, fields_attributes: [
          :id, :value, :file, :field_template_id, :_destroy, value: [], children_attributes: nodes
        ]]
      
    end
  
    private 
  
    def count_levels(node_params, att_name)
       if node_params.try(:[], att_name).present?
        max = 0
        node_params[att_name].each do |child_params|
          count = count_levels(child_params[1], att_name)
          max = count if count > max
        end
        return max + 1
      else
        return 0
      end
    end
  end
end