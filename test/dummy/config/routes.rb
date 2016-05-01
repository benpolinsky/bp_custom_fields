Rails.application.routes.draw do
  mount BpCustomFields::Engine => "/custom_fields"
end
