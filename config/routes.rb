Rails.application.routes.draw do
  root 'trips#index'

  resources :trips

  devise_for :users
end
