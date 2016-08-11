module BpCustomFields
  class Railtie < Rails::Railtie
    initializer "bp_custom_fields.initialize" do
      ActiveSupport.on_load(:action_view) do
        include BpCustomFields::FormHelper
        include BpCustomFields::FieldsHelper
        include BpCustomFields::DisplayHelper
        include BpCustomFields::ParameterHelper
        include BpCustomFields::AbstractResourceHelper
      end
      ActiveSupport.on_load(:action_controller) do
        include BpCustomFields::DisplayHelper
        include BpCustomFields::ParameterHelper
      end
      config.to_prepare do
        require 'bp_custom_fields/application_controller'
     end
    end
  end
end