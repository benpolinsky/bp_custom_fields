Rails.application.routes.draw do


  mount BpCustomFields::Engine => "/custom_fields"

  resources :posts, :people

  # get 'home' => 'home#index'
  # get 'home/post/:id' => 'home#post'
  root to: 'posts#index'

end
