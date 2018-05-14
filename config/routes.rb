Rails.application.routes.draw do
  root 'trips#index'
  devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

  resources :trips
  resources :users, only: [:show]

end
