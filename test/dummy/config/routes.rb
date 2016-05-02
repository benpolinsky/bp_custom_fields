Rails.application.routes.draw do

  mount BpCustomFields::Engine => "/custom_fields"

  resources :posts
  root to: 'posts#index'

end
