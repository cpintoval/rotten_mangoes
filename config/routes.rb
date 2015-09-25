RottenMangoes::Application.routes.draw do

  resources :movies do
    resources :reviews, only: [:new, :create]
  end
  resources :users, only: [:new, :create, :show]
  resource :sessions, only: [:new, :create, :destroy, :update]
  root to: 'movies#index'

  namespace :admin do
    resources :users
  end

  get '/search', to: 'movies#search', as: 'search_movie'

end
