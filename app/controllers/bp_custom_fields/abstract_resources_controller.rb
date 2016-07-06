module BpCustomFields
  class AbstractResourcesController < ApplicationController
    def index
      @abstract_resources = BpCustomFields::AbstractResource.find_or_create_from_appearances(Appearance.abstract)
    end
    
    def edit
      @abstract_resource = BpCustomFields::AbstractResource.find(params[:id])
    end
    
    # def save
    #   @abstract_appearance = BpCustomFields::Appearance.abstract.where(resource_id: group_params[:abstract_appearance_resource_id]).first
    #   @group = BpCustomFields::FieldManager.initialize_group_with_fields(@abstract_appearance.group_template)
    #   @group.assign_attributes(group_params.except(:abstract_appearance_resource_id))
    #   if @group.save
    #     redirect_to bp_custom_fields.edit_abstract_resource_path(@abstract_appearance.resource_id)
    #   else
    #     render :edit
    #   end
    # end
    
    def update
      @abstract_resource = BpCustomFields::AbstractResource.find(params[:id])
      if @abstract_resource.update_attributes(abstract_resource_params)
        redirect_to bp_custom_fields.edit_abstract_resource_path(@abstract_resource), notice: "Abstract Resource Updated!"
      else
        render :edit
      end
    end
    
    
    
    
    
    protected
    
    def abstract_resource_params
      params.require(:abstract_resource).permit(:id, bpcf_fieldable_permitted_params(params))
    end
  end
end