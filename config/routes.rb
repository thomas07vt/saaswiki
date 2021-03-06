Saaswiki::Application.routes.draw do
  get "subscriptions/finalize"
  get "subscriptions/edit"

  get "username_suggestions", :to => "assigned_wikis#username_suggestions"

  devise_for :users, :controllers => {registrations: "registrations" }
  
  resources :subscriptions, only: [:update, :edit]

  resource :dashboard, only: [:show]

  #resources :assigned_wikis, only: [:new, :create, :destroy, :update]

  resources :users, only: [:show, :update] do
    resources :wikis, only: [:index]
  end

  resources :wikis do
    resources :assigned_wikis, only: [:new, :create, :destroy, :update, :index]
  end
  
  # get "wikis/:id/access", to: 'wikis#access', as: 'wiki_access'

  resources :charges, only: [:new, :create]


  authenticated :user do
   root to: 'dashboards#show', as: 'authenticated_root'
  end

  root to: 'home#index'
  
end
