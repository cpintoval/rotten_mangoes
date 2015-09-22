RottenMangoes::Application.routes.draw do

  resources :movies
  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy]

end
