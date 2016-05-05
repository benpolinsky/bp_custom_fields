module BpCustomFields
  module ParametersHelper
    def bp_custom_field_params
      {groups_attributes: [:id, fields_attributes: [:id, :value]]}
    end
  end
end