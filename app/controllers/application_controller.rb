class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def calificar(user, cal)
    if cal.tipo_calificacion == 'p'
      user.update_attributes(calificacionPiloto: (user.calificacionPiloto + cal.calificacion))
      if user.calificacionPiloto < 0
        user.update_attributes(calificacionPiloto: 0)
      end
    else
      user.update_attributes(calificacionCopiloto: (user.calificacionCopiloto + cal.calificacion))
      if user.calificacionCopiloto < 0
        user.update_attributes(calificacionCopiloto: 0)
      end
    end
  end

  def mismaHora?(u, v)
    emb = Embarkment.joins(:trip).where('trips.fecha_inicio': v.fecha_inicio,
        'trips.hora_inicio': v.hora_inicio, estado: 'a',
        'trips.activo': true)
    return false if emb.empty?
    emb.all.each do |e|
      return true if e.user == u
    end
  end

  def deuda?(user)
    user.account.deuda? || user.account.saldo < 0
  end

  def calificacionesPendientes?(user)
    user.calif_creadas.exists?(realizada: false)
  end

  def viajesPendientes?(user)
    !Embarkment.joins(:trip).where(estado: 'a', user_id: user, "trips.activo": true).empty? ||
    !Trip.where(activo: true, piloto: user).empty?
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
