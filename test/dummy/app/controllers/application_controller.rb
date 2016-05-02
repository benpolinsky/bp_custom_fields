class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # TODO: include dynamically from engine
  before_action :find_custom_fields
  after_action :save_custom_fields
  
  def save_custom_fields
    if params[:custom_field_groups].present?
      params[:custom_field_groups].each do |group_id, fields|
        group = BpCustomFields::Group.find(group_id)
        fields.each do |field_id, field|
          group.fields.find(field_id).update(value: field)
        end
      end
    else
    end
  end 
end
