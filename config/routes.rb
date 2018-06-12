Rails.application.routes.draw do

	root 'trips#index'
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

	get '/users', to: 'users#show'

	resources :users do
		resources :trips do
      collection do
        put :aceptar
        put :rechazar
      end
    end
		resources :vehicles
	end

end
