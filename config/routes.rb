Saaswiki::Application.routes.draw do
  get "wikis/index"
  get "wikis/show"
  get "wikis/new"
  get "wikis/edit"
  devise_for :users
  resource :dashboard, only: [:show]

  resources :users, only: [:show, :update] do
    resources :wikis, only: [:index]
  end

  resources :wikis


  authenticated :user do
   root to: 'dashboards#show', as: 'authenticated_root'
  end

  root to: 'home#index'
  

end
