Rails.application.routes.draw do

	root 'trips#index'
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

	get '/users', to: 'users#show'

	resources :users do
		resources :trips do
      member do
        put :aceptar
        put :rechazar
        put :eliminar
      end
    end
		resources :vehicles
	end

end
