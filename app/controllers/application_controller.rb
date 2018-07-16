class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :viajesPasados
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
#SI SE MODIFICA ACÁ, MODIFICAR EN TRIP.RB
  def seleccionar_periodicos(lista_de_viajes)
    lista_a_devolver = []
    lista_de_viajes.each do |v|
      if !v.periodics.empty?
        lista_a_devolver.add(v)
      end
    end
    return lista_a_devolver
  end

  def mismaHora?(u, v)
    #si éste viaje se cruza con algun otro para ese mismo usuario
    emb = Embarkment.joins(:trip).where('embarkments.user_id': u.id, estado: 'a', 
                                        'trips.activo': true)
    emb.delete(v)
    emb.all.each do |e|
        if e.fecha_inicio_exacta >= v.fecha_inicio_exacta and e.fecha_inicio_exacta <= 
                                                                v.fecha_fin_exacta
          return true
        end
    end
    viajes_periodicos = seleccionar_periodicos(Trip.where(piloto: u.id, activo: true) + Trip.joins(emb))
    viajes_periodicos.each do |vp|
      vp.periodics.each do |fecha_periodica|
        fecha_periodica_exacta = fecha_periodica.fecha.beginning_of_day() + 
                                    vp.hora_inicio.seconds_since_midnight
        if fecha_periodica_exacta >= v.fecha_inicio_exacta  and fecha_periodica_exacta <= 
                                                                  v.fecha_fin_exacta
          return true
        end
      end
    end
    return false
  end

  def vehiculo_mismaHora?(vehiculo,viaje)
    viajes = Trip.where(:vehicle_id => vehiculo)
    viajes.delete(viaje)
    return false if viajes.empty?
    viajes.all.each do |v|
        if v.fecha_inicio_exacta >= viaje.fecha_inicio_exacta and v.fecha_inicio_exacta <= 
                                                                viaje.fecha_fin_exacta
          return true
        end
    end
    seleccionar_periodicos(viajes).each do |vp|
      vp.periodics.all do |fecha_periodica|
        fecha_periodica_exacta = fecha_periodica.fecha.beginning_of_day() + 
                                    vp.hora_inicio.seconds_since_midnight
        if fecha_periodica_exacta >= viaje.fecha_inicio_exacta  and fecha_periodica_exacta <= 
                                                                  viaje.fecha_fin_exacta
          return true
        end
      end
    end
    return false
  end
#<<<<<<<<<<<<

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
    def viajesPasados
      fecha = Time.now.year.to_s + '-' + Time.now.month.to_s + '-' + Time.now.day.to_s
      hora = Time.now.strftime("%H:%M")
      Trip.where("activo = ? and fecha_inicio <= ?", true, fecha).all.each do |trip|
        horaInicio = trip.hora_inicio.strftime("%H:%M")
        total = (trip.costo / trip.cantidad_asientos_ocupados).round(2)
        if (trip.fecha_inicio == Date.today && horaInicio <= hora) ||
           (trip.fecha_inicio < Date.today)
          trip.update_attribute(:activo, false)
          trip.piloto.account.update_attributes(deuda: (trip.piloto.account.deuda+((trip.costo * 0.05).round(2))))
          trip.postulantes.each do |pos|
            if Embarkment.find_by(trip_id: trip, user_id: pos, estado: 'a').present?
              Score.create(calificado: pos, creador: trip.piloto, realizada: false, tipo_calificacion: 'c')
              Score.create(calificado: trip.piloto, creador: pos, realizada: false, tipo_calificacion: 'p')
              e = Embarkment.find_by(trip_id: trip, user_id: pos, estado: 'a')
              e.update_attributes(deuda: total)
              pos.account.update_attributes(deuda: (pos.account.deuda+total).round(2))
            end
          end
        end
      end
    end

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
