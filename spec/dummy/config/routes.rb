Rails.application.routes.draw do

  resources :people
  resources :people
  mount BpCustomFields::Engine => "/custom_fields"

  resources :posts
  root to: 'posts#index'

end
