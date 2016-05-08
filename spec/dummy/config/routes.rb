Rails.application.routes.draw do


  mount BpCustomFields::Engine => "/custom_fields"

  resources :posts, :people

  get 'home' => 'home#index'
  root to: 'posts#index'

end
