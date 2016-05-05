BpCustomFields::Engine.routes.draw do
  resources :group_templates do
    resources :field_templates 
  end
  root to: 'group_templates#index'
end
