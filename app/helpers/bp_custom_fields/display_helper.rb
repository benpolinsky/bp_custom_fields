module BpCustomFields
  module DisplayHelper
    def bp_display_video(address)
      video = BpCustomFields::Video.new(address)
      video_embed_html(video)
    end
    
    def bpcf_group_template_permitted_params(params)
      node_attributes_base = [:_destroy, :field_type, :required, :min, :max, :prepend, :append, :required, :default_value, 
          :instructions, :label, :placeholder_text, :id, :name, :rows, :accepted_file_types, :toolbar, 
          :date_format, :time_format, :choices, :multiple, :parent_id]
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
    
    #
    # def recursive_params(params)
    #   sub_groups_base = [:_destroy, :id, :is_sub_group, :parent_field_id]
    #   fields_base = [:id, :value, :file, :field_template_id, {value: []}, {children_attributes: [
    #         :id, :value, :file, :field_template_id, :parent_id, value: []]}, {sub_groups_attributes: sub_groups_base}]
    #
    #   field_nodes = []
    #
    #   if params.present?
    #     params.values.each do |inner_params|
    #       (1..count_levels(inner_params, :fields_attributes)).each do |val|
    #         byebug
    #         field_nodes = fields_base.last[:sub_groups_attributes] += [fields_attributes: field_nodes]
    #       end
    #     end
    #   end
    # {groups_attributes: [:group_template_id, :id, field_nodes]}
    #
    # end
    

  
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
    
    # def count_alternating_levels(node_params, att_name, alt_att_name)
    #    if node_params.try(:[], att_name).present?
    #     max = 0
    #     node_params[att_name].each do |child_params|
    #       count = count_alternating_levels(child_params[1], alt_att_name, att_name)
    #       max = count if count > max
    #     end
    #     return max + 1
    #   else
    #     return 0
    #   end
    # end

    
    
    def video_embed_html(video)
      content_tag :div, class: "bpcf-embed-container" do
        content_tag :iframe, nil, src: video.embed_address, frameborder: 0, allowfullscreen: ''
      end
    end
  end
end