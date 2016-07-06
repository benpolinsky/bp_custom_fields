module BpCustomFields
  module AbstractResourceHelper
    def abstract_resource_admin_nav
      @abstract_resource_names = BpCustomFields::AbstractResource.all
      capture do
        @abstract_resource_names.each do |page|
          concat link_to(page.name.titleize, bp_custom_fields.edit_abstract_resource_path(page), class: "nav-item nav-link")
        end
      end
    end
  end  
end
