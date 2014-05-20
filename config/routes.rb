Saaswiki::Application.routes.draw do
  get "subscriptions/finalize"


  devise_for :users, :controllers => {registrations: "registrations" }
  

  resources :subscriptions, only: [:new, :create, :cancel, :update, :edit]

  resource :dashboard, only: [:show]

  resources :users, only: [:show, :update] do
    resources :wikis, only: [:index]
  end

  resources :wikis

  resources :charges, only: [:new, :create]


  authenticated :user do
   root to: 'dashboards#show', as: 'authenticated_root'
  end

  root to: 'home#index'
  

end
