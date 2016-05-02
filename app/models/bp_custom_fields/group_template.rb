module BpCustomFields
  class GroupTemplate < ActiveRecord::Base
    has_many :field_templates
    has_many :groups
    
    accepts_nested_attributes_for :field_templates, reject_if: :all_blank_except_required, allow_destroy: true
    after_create :update_target_models

    validates :name, presence: true
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
  
    # when we add a new custom field, we'll add it to the #appears_on model via a callback on fieldable
    # however, we should check here if any appears_on models exist already when created
    # if there are, there's no way they'll have the groups, so we need to add it
    
    def update_target_models
      target_model = appears_on.constantize
      if target_model.all.any?
        target_model.all.each do |tm|
          tm.groups << self.groups.new
        end
      end
    end
    
    # I THINK that it'll automatically be deleted from the target model when deleted here.. 
    
    
    # def self.find_for_location(request)
    #
    #   controller = request[:controller]
    #   action = request[:action]
    #   other_params = request.parameters.except(:controller, :action)
    #
    #   request_method = request.method
    #   fullpath = request.fullpath
    #   tbl = self.arel_table
    #
    #   # query = self.where(tbl[:location].eq(controller).or(tbl[:location].eq("#{controller}/#{action}")))
    #   query = self.where("location LIKE ?", "%#{controller}%")
    #   query
    # end
    
    
  end
end
