Rails.application.routes.draw do


  mount BpCustomFields::Engine => "/custom_fields"

  resources :posts, :people
  root to: 'posts#index'

end
