class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def calificarPositivamente(user, tipo)
    if tipo == 'piloto'
      user.increment!(:calificacionPiloto, 1)
    else
      user.increment!(:calificacionCopiloto, 1)
    end
  end

  def calificarNegativamente(user, tipo)
    if tipo == 'piloto'
      unless user.calificacionPiloto == 0
        user.decrement!(:calificacionPiloto, 1)
      end
    else
      unless user.calificacionCopiloto == 0
        user.decrement!(:calificacionCopiloto, 1)
      end
    end
  end

  protected
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up) { |u|
        u.permit(:nombre, :apellido, :fecha_nacimiento, :email, :password,
                 :password_confirmation)
      }
      devise_parameter_sanitizer.permit(:account_update) { |u|
        u.permit(:password, :password_confirmation, :current_password,
                 :nombre, :apellido, :avatar, :telefono, :tarjeta,
                 :fecha_nacimiento, :fecha_vencimiento)
      }
    end
end
