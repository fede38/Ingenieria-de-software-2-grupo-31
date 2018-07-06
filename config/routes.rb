Rails.application.routes.draw do

	root 'trips#index'
	devise_for :users, :controllers => {:registrations => "my_devise/registrations"}

	get '/users', to: 'users#show'
  get '/users/:id/postulaciones', to: 'users#postulaciones'
  get '/users/:id/showMisViajes', to: 'trips#showMisViajes'
  get '/ayuda', to: 'static_pages#ayuda'
  get '/contactanos', to: 'static_pages#contacto'

	resources :users do
    collection do
      put :pagarTodoSaldo
      put :pagarTodoTarjeta
      put :pagarViajeSaldo
      put :pagarViajeTarjeta
    end
    resources :accounts, only: [:index]
    resources :trips do
      member do
        put :aceptar
        put :rechazar
        put :postularse
        delete :cancelarPostulacion
        delete :eliminar
      end
    end
    resources :scores, only: [:edit, :update]
    member do
      get 'calificaciones', to: 'scores#showCalificaciones'
      get 'calificaciones_pendientes', to: 'scores#showCalifARealizar'
    end
		resources :vehicles
  end

end
