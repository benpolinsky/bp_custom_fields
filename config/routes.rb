BpCustomFields::Engine.routes.draw do
  resources :group_templates do
    resources :field_templates do
      collection do
        get 'manage'
      end
    end
  end
  root to: 'group_templates#index'
end
