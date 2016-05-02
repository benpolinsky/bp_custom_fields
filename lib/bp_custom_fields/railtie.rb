module BpCustomFields
  class Railtie < Rails::Railtie
    initializer "bp_custom_fields.action_view" do
      ActiveSupport.on_load(:action_view) do
        include BpCustomFields::DisplayHelper
      end
    end
    
    initializer "bp_custom_fields.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include BpCustomFields::DisplayHelper
      end
    end
  end
end