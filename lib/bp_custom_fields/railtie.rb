module BpCustomFields
  class Railtie < Rails::Railtie
    initializer "bp_custom_fields.initialize" do
      ActiveSupport.on_load(:action_view) do
        include BpCustomFields::FormHelper
        include BpCustomFields::FieldsHelper
        include BpCustomFields::DisplayHelper
      end
      ActiveSupport.on_load :action_controller do
        include BpCustomFields::DisplayHelper
     end
    end
  end
end