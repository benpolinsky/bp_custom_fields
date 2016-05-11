require_dependency "bp_custom_fields/application_controller"

module BpCustomFields
  class GroupTemplatesController < ApplicationController
    before_action :set_group_template, only: [:show, :edit, :update, :destroy]
    before_action :set_all_application_models, only: [:new, :edit]
    
    # GET /groups
    def index
      @group_templates = GroupTemplate.all
    end

    # GET /groups/1
    def show
    end

    # GET /groups/new
    def new
      @group_template = GroupTemplate.new
      @group_template.appearances.build if @group_template.appearances.none?
      @group_template.field_templates.build if @group_template.field_templates.none?
    end

    # GET /groups/1/edit
    def edit
      @group_template.appearances.build if @group_template.appearances.none?
      @group_template.field_templates.build if @group_template.field_templates.none?
    end

    # POST /groups
    def create
      @group_template = GroupTemplate.new(group_template_params)

      if @group_template.save
        redirect_to edit_group_template_path(@group_template), notice: 'Group was successfully created.'
      else
        set_all_application_models
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      if @group_template.update_and_reload_fields(group_template_params)
        redirect_to edit_group_template_path(@group_template), notice: 'Group was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /groups/1
    def destroy
      @group_template.destroy
      redirect_to group_templates_url, notice: 'Group was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group_template
        @group_template = GroupTemplate.find(params[:id])
      end

      def set_all_application_models
        Rails.application.eager_load!
        @app_models = ActiveRecord::Base.descendants.reject {|d| BpCustomFields::EXCLUDED_MODELS.include?(d.name)}.map(&:name)
      end

      # Only allow a trusted parameter "white list" through.
      def group_template_params
        params.require(:group_template).permit(:name, :visible, field_templates_attributes: [:_destroy, :field_type, :required, :min, :max, :prepend, :append, :required, :default_value, :instructions, :label, :placeholder_text, :id, :name, :options => [:an_option]], appearances_attributes: [:_destroy, :id, :resource, :resource_id, :appears])
      end
  end
end
