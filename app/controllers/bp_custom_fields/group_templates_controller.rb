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
      @group_template.appearances.build
    end

    # GET /groups/1/edit
    def edit
    end

    # POST /groups
    def create
      @group_template = GroupTemplate.new(group_template_params)

      if @group_template.save
        redirect_to edit_group_template_path(@group_template), notice: 'Group was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /groups/1
    def update
      if @group_template.update(group_template_params)
        redirect_to @group_template, notice: 'Group was successfully updated.'
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
        @app_models = ActiveRecord::Base.descendants.reject {|d| d.name == "ActiveRecord::SchemaMigration"}.map(&:name)
      end

      # Only allow a trusted parameter "white list" through.
      def group_template_params
        params.require(:group_template).permit(:name, :visible, field_templates_attributes: [:field_type, :required, :min, :max, :prepend, :required, :default_value, :instructions, :label, :placeholder_text, :id, :name], appearances_attributes: [:id, :resource, :resource_id, :appears])
      end
  end
end
