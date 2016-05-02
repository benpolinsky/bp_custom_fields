require_dependency "bp_custom_fields/application_controller"

module BpCustomFields
  class GroupTemplatesController < ApplicationController
    before_action :set_group_template, only: [:show, :edit, :update, :destroy]

    # GET /groups
    def index
      @group_templates = Group.all
    end

    # GET /groups/1
    def show
    end

    # GET /groups/new
    def new
      @group_templates = Group.new
    end

    # GET /groups/1/edit
    def edit
    end

    # POST /groups
    def create
      @group_templates = Group.new(group_template_params)

      if @group_templates.save
        redirect_to @group_templates, notice: 'Group was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      if @group_templates.update(group_template_params)
        redirect_to @group_templates, notice: 'Group was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /groups/1
    def destroy
      @group_templates.destroy
      redirect_to group_templates_url, notice: 'Group was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group_template
        @group_templates = Group.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def group_template_params
        params.require(:group_template).permit(:name, :location, :visible, field_templates_attributes: [:field_type, :required, :min, :max, :prepend, :required, :default_value, :instructions, :label, :placeholder_text, :id, :name])
      end
  end
end
