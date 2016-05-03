module BpCustomFields
  class GroupTemplate < ActiveRecord::Base
    has_many :field_templates
    has_many :groups, dependent: :destroy
    has_many :appearances
    
    accepts_nested_attributes_for :field_templates, reject_if: :all_blank_except_required, allow_destroy: true
    after_create :update_target_models

    validates :name, presence: true
    validates :appearances, presence: true
    
    def all_blank_except_required(attrs)
      attrs.except(:required).values.all?(&:blank?)
    end
  
    
    def update_target_models
      begin
        target_model = appearances.first.resource.constantize        
        if target_model.all.any?
          target_model.all.each do |tm| 
            tm.groups << self.groups.create
            tm.groups.each {|group| group.create_fields_from_templates }
          end
        end
      rescue Exception => e
        #puts e
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
