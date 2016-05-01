BpCustomFields::Engine.routes.draw do
  resources :groups do
    resources :fields
  end
  root to: 'groups#index'
end
