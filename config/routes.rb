Rails.application.routes.draw do

	root 'trips#index'
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

	get '/users', to: 'users#show'

	resources :trips
	resources :users do
		resources :vehicles
	end
end
