BpCustomFields::Engine.routes.draw do
  resources :groups do
    resources :fields do
      collection do
        get 'manage'
      end
    end
  end
  root to: 'groups#index'
end
