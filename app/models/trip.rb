class Trip < ApplicationRecord
  default_scope { order(origen: :asc, destino: :asc) }

  belongs_to :piloto, class_name: 'User', foreign_key: 'user_id'
  belongs_to :vehicle
  
  has_many :periodics, inverse_of: :trip
  accepts_nested_attributes_for :periodics

  has_many :embarkment
  has_many :postulantes, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'
  has_many :questions

  validates :destino, :origen, :vehicle_id, :costo, :duracion, :fecha_inicio, :hora_inicio, presence: true
  
  validate :costo_mayor_a_cero
  validate :duracion_mayor_a_cero
  validate :fecha_mayor_a_hoy
  validate :hora_mayor_a_ahora

  validate :saldo_en_contra, on: :create
  validate :calificaciones_pendientes, on: :create

  validate :viaje_a_la_misma_hora
  validate :vehiculo_no_en_viaje
  # validate :viajePostulado_a_la_misma_hora
  # validate :viajePiloto_a_la_misma_hora
  
  #Validaciones de viajes periódicos
  validate :fechas_que_no_se_crucen
  validate :fechas_mayores_a_hoy
  validate :horas_mayores_a_ahora
  validate :diferentes_de_inicio
  validate :posteriores_a_inicio
  validate :inferior_a_treinta_dias

  def fecha_inicio_exacta
    return self.fecha_inicio.beginning_of_day() + self.hora_inicio.seconds_since_midnight
    #return Time.at(self.fecha_inicio + self.hora_inicio.hour*3600 + self.hora_inicio.min*60 + 
     #               self.hora_inicio.sec)
  end

  def fecha_fin_exacta
    return self.fecha_inicio_exacta + self.duracion*3600
    #return Time.at(self.fecha_inicio_exacta + self.duracion*3600)
  end

  def inferior_a_treinta_dias
    respuesta = false
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha > self.fecha_inicio + 30.days
          respuesta = true
        end
      end
    end
    if respuesta
      errors.add("La fecha, ", 'debe ser de un máximo de 30 dias a partir del inicio')
    end
  end

  def posteriores_a_inicio
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha < self.fecha_inicio || (periodica.fecha == self.fecha_inicio && 
                        periodica.hora.strftime('%H:%M') < self.hora_inicio.strftime('%H:%M') )
          errors.add("Las fechas y horas, ", 'deben ser posteriores a la de inicio')
        end
      end
    end
  end

  def diferentes_de_inicio
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha == self.fecha_inicio && periodica.hora.strftime('%H:%M') == 
                                                    self.hora_inicio.strftime('%H:%M')
          errors.add("Las fechas, ", 'deben ser diferentes a la primera fecha')
        end
      end
    end
  end

  def fechas_mayores_a_hoy
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha < Date.today
          errors.add("Las fechas,", 'deben ser posteriores a hoy')
        end
      end
    end
  end

  def horas_mayores_a_ahora
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha == Date.today && periodica.hora.strftime('%H:%M') < Time.now.strftime('%H:%M')
          errors.add("La hora", 'debe ser posterior a ahora.')   
        end
      end
    end
  end

  def fechas_que_no_se_crucen
    x = false
    if self.periodics
      self.periodics do |periodica|
        self.periodics do |other|
          if periodica != other
            x = periodica.fecha == other.fecha && periodica.hora.strftime('%H:%M') ==
                                                    other.hora.strftime('%H:%M')
          end
        end
      end
    end
    if x
      errors.add("Dos fechas y horas, ", 'no pueden ser iguales')
    end
  end

  def fecha_mayor_a_hoy
  	if self.fecha_inicio and self.fecha_inicio < Date.today
  		errors.add("La fecha de inicio debe ser hoy o ", 'posterior a hoy.')
  		end
  end

  def hora_mayor_a_ahora
  	if (self.fecha_inicio == Date.today) and (self.hora_inicio.strftime('%H:%M') <
                  Time.now.strftime('%H:%M'))
  			errors.add("La fecha y hora deben ser ", 'posteriores a ahora.')
  	end
  end

  def viaje_a_la_misma_hora
    if self.fecha_inicio and self.hora_inicio and mismaHora?(self.piloto,self)
      errors.add("Tienes un viaje ", 'pendiente que se cruza con éste viaje')
    end
  end

  # def viajePostulado_a_la_misma_hora
  # 	if self.piloto.viajesPostulado.detect{ |t| t.id != self.id and t.fecha_inicio == self.fecha_inicio and
  # 											t.hora_inicio == self.hora_inicio }
  # 		errors.add("Estas postulado a un viaje,", ' a la misma hora, el mismo día que éste.')
  # 	end
  # end

  # def viajePiloto_a_la_misma_hora
  # 	if self.piloto.viajesPiloto.detect{ |t| t.id != self.id and t.fecha_inicio == self.fecha_inicio and
  # 											t.hora_inicio == self.hora_inicio }
  # 		errors.add("Tienes un viaje pendiente,", ' a la misma hora, el mismo día que éste.')
  # 	end
  # end

  def saldo_en_contra
  	if self.piloto.account.deuda? or self.piloto.account.saldo < 0
  		errors.add("No puedes crear un viaje ", 'si tienes deuda pendiente')
  	end
  end

  def vehiculo_no_en_viaje
  	if self.fecha_inicio and self.hora_inicio and vehiculo_mismaHora?(self.vehicle_id,self)
  		errors.add("El vehículo elegido",' tiene un viaje asignado que se cruza con éste.')
  	end
  end

  def calificaciones_pendientes
  	if self.piloto.calif_creadas.detect{ |c| !c.realizada }
  		errors.add("No puedes crear un viaje ", 'si tienes calificaciones pendientes')
  	end
  end

  def costo_mayor_a_cero
    if self.costo
      if self.costo <= 0
        errors.add("El costo", ' debe ser mayor a (0) cero')
      end
    end
  end

  def duracion_mayor_a_cero
    if self.duracion
      if self.duracion <= 0
        errors.add("La duración", ' debe ser mayor a (0) cero')
      end
    end
  end

end

#SI SE MODIFICA ACÁ, MODIFICAR EN APPLICATION_CONTROLLER.RB
  def seleccionar_periodicos(lista_de_viajes)
    lista_a_devolver = []
    lista_de_viajes.each do |v|
      if !v.periodics.empty?
        lista_a_devolver << v
      end
    end
    return lista_a_devolver
  end

  def mismaHora?(u, v)
    #si éste viaje se cruza con algun otro para ese mismo usuario
    viajes = u.viajesPiloto + u.viajesPostulado
    viajes = viajes - [v]
    viajes = viajes.select{ |trip| trip.activo }
    return se_cruzan?(viajes,v)
  end

  def vehiculo_mismaHora?(id_vehiculo,viaje)
    viajes_totales = Trip.where(:vehicle_id => id_vehiculo)
    viajes = viajes_totales - [viaje]
    viajes = viajes.select{ |trip| trip.activo }
    return se_cruzan?(viajes,viaje)
  end

  def se_cruzan?(viajes,v) #recibe un array de viajes y un un viaje especifico
    return false if viajes.empty?
    #checkea fijas de viajes contra fija de v
    viajes.each do |t|
        if t.fecha_inicio_exacta.between?(v.fecha_inicio_exacta,v.fecha_fin_exacta) or 
              t.fecha_fin_exacta.between?(v.fecha_inicio_exacta,v.fecha_fin_exacta)
          return true
        end
    end
    seleccionar_periodicos(viajes).each do |vp|
      vp.periodics.each do |fp|
        fp_inicio = fp.fecha.beginning_of_day() + vp.hora_inicio.seconds_since_midnight
        fp_fin = fp_inicio + vp.duracion*3600
        #checkea periodicas contra la fecha fija de v
        if fp_inicio.between?(v.fecha_inicio_exacta,v.fecha_fin_exacta) or 
          fp_fin.between?(v.fecha_inicio_exacta,v.fecha_fin_exacta) 
          return true
        end
        #checkea periodicas de v contra las fechas periodcas
        if !v.periodics.empty?
          v.periodics.each do |fp_de_v| #sacado el .all
            fp_de_v_inicio = fp_de_v.fecha.beginning_of_day() + 
                              v.hora_inicio.seconds_since_midnight
            fp_de_v_fin = fp_de_v_inicio + v.duracion*3600
            if fp_de_v_inicio.between?(fp_inicio,fp_fin) or 
                fp_de_v_fin.between?(fp_inicio,fp_fin)
                return true
            end
          end
        end
      end
    end
    return false
  end
#<<<<<<<<<<