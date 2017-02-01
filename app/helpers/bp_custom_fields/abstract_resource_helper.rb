
module BpCustomFields
  module AbstractResourceHelper

    # Helper for displaying links to manage abstract resources.
    # Because abstract resources are merely wrappers around
    # loosely(?) bound custom field groups, it's nice to have
    # an easy way to link to them.
    
    # Usage: <%= abstract_resource_admin_nav %> 
        
    def abstract_resource_admin_nav
      @abstract_resources = BpCustomFields::AbstractResource.all
      
      # No reason to render if we have nothing...
      return if abstract_resources_unavailable
      
      # Loop through resources and display a link.
      capture do
        content_tag :div, class: 'abstract-resource-navigation' do 
          @abstract_resources.each do |page|
            concat link_to(page.name.titleize, bp_custom_fields.edit_abstract_resource_path(page), class: "nav-item nav-link abstract-resource-link")
          end
        end
      end
      
    end
    
    private
    
    def abstract_resources_unavailable
      @abstract_resources.none? || @abstract_resources.map(&:groups).flatten.none? 
      # @abstract_resources.map{|r| r.groups.map(&:group_template)}.flatten.map(&:appearances).flatten.none?
      
    end
    
  end  
end
