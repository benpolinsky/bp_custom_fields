BpCustomFields::Engine.routes.draw do
  resources :group_templates do
    resources :field_templates 
  end
  resources :abstract_resources do
    post 'save', on: :collection
    patch 'save', on: :collection
  end
  root to: 'group_templates#index'
end
