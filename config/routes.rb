Rails.application.routes.draw do
 	
 	root 'trips#index'
 	
	devise_for :users

	resources :trips
	resources :users do
		resources :vehicles
	end
end
