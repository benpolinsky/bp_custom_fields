require_dependency "bp_custom_fields/application_controller"

module BpCustomFields
  class FieldsController < ApplicationController
    before_action :find_group
    def index
      @group.fields.build 
    end
    
    protected
    def find_group
      @group = Group.find(params[:group_id])
    end
  end
end
