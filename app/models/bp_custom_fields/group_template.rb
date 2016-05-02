module BpCustomFields
  class GroupTemplate < ActiveRecord::Base
    has_many :field_templates
    has_many :groups
    
    accepts_nested_attributes_for :field_templates, reject_if: :all_blank_except_required, allow_destroy: true

    validates :name, presence: true
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
    
    def self.find_for_location(request)

      controller = request[:controller]
      action = request[:action]
      other_params = request.parameters.except(:controller, :action)
      
      request_method = request.method
      fullpath = request.fullpath
      tbl = self.arel_table
      
      # query = self.where(tbl[:location].eq(controller).or(tbl[:location].eq("#{controller}/#{action}")))
      query = self.where("location LIKE ?", "%#{controller}%")
      query
    end
  end
end
