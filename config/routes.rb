RottenMangoes::Application.routes.draw do
  
  get "sessions/new"
  get "sessions/create"
  resources :movies
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create]

end
