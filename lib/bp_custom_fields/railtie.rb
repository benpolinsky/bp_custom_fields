module BpCustomFields
  class Railtie < Rails::Railtie
    initializer "bp_custom_fields.initialize" do
      ActiveSupport.on_load(:action_view) do
        include BpCustomFields::FormHelper
        include BpCustomFields::FieldsHelper
        include BpCustomFields::DisplayHelper
      end
    end
    
    initializer "bp_custom_fields.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include BpCustomFields::ParametersHelper # are you using this?/does it work?
      end
    end
  end
end