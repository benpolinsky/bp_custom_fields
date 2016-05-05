require_dependency "bp_custom_fields/application_controller"

module BpCustomFields
  class FieldTemplatesController < ApplicationController
    before_action :find_group_template
    
    
    protected
    def find_group_template
      @group_template = GroupTemplate.find(params[:group_template_id])
    end
  end
end
