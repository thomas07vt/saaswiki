Saaswiki::Application.routes.draw do
  devise_for :users
  resource :dashboard, only: [:show]

  resources :users, only: [:show, :update]


  authenticated :user do
   root to: 'dashboards#show', as: 'authenticated_root'
  end

  root to: 'home#index'
  

end
