Rails.application.routes.draw do
  root 'trips#index'
  devise_for :users

  resources :trips
  resources :users, only: [:show]

  resources :vehicles
end
