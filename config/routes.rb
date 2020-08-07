Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'signup', to: 'users#new'
  get 'users', to: 'users#new'
  resources :users, param: :name, only: [:show, :create, :edit, :update] do
    member do
      get :followings
      get :followers
      get :favorites
    end
  end
  
  get 'photoposts', to: 'photoposts#new'
  
  resources :photoposts, only: [:show, :new, :create, :destroy] do
    get :search, on: :collection
  end
  post 'photoposts/search', to: 'photoposts#search'
  
  resources :relationships, only: [:create, :destroy]
  
   resources :favorites, only: [:create, :destroy]
  
end