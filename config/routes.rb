Rails.application.routes.draw do

	root 'trips#index'
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

	get '/users', to: 'users#show'
  get '/users/:id/postulaciones', to: 'users#postulaciones'
  # get 'users/:id/showCalificaciones', to: 'scores#showCalificaciones'


	resources :users do
		resources :trips do
      member do
        put :aceptar
        put :rechazar
        delete :cancelarPostulacion
        delete :eliminar
      end
    end
		resources :vehicles
    get 'users/:id/showCalificaciones', to: 'scores#showCalificaciones'
	end

end
