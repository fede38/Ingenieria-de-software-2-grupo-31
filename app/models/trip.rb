class Trip < ApplicationRecord
  default_scope { order(origen: :asc, destino: :asc) }

  belongs_to :p
  piloto, class_name: 'User', foreign_key: 'user_id'
  belongs_to :vehicle
  
  has_many :periodics, inverse_of: :trip
  accepts_nested_attributes_for :periodics



  has_many :embarkment
  has_many :postulantes, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'

  validates :destino, :origen, :vehicle_id, :costo, :fecha_inicio, :hora_inicio, presence: true

  validate :costo_mayor_a_cero
  validate :fecha_mayor_a_hoy
  validate :hora_mayor_a_ahora
  validate :vehiculo_no_en_viaje
  validate :viajePostulado_a_la_misma_hora
  validate :viajePiloto_a_la_misma_hora

  validate :saldo_en_contra, on: :create
  validate :calificaciones_pendientes, on: :create
  
  #Validaciones de viajes periódicos
  validate :fechas_que_no_se_crucen
  validate :fechas_mayores_a_hoy
  validate :horas_mayores_a_ahora
  validate :diferentes_de_inicio
  validate :posteriores_a_inicio

  def periodics
    return self.periodics
  end

  def se_cruza_con(unViaje)
    if self.fecha_inicio == unViaje.fecha_inicio && self.hora_inicio.strftime('%H:%M') == 
                                                      unViaje.hora_inicio.strftime('%H:%M')
      return true
    end
    if self.periodics
      self.periodics do |periodica|
        if periodica.fecha == unViaje.fecha_inicio && periodica.hora.strftime('%H:%M') ==
                                                        unViaje.hora_inicio.strftime('%H:%M')
          return true
        end
        unViaje.periodics do |unViajePeriodica|
          if periodica.fecha == unViajePeriodica.fecha && periodica.hora.strftime('%H:%M') == 
                                                            unViajePeriodica.hora.strftime('%H:%M')
            return true
          end
        end
      end
      unViaje.periodics do |unViajePeriodica|
        if unViajePeriodica.fecha == self.fecha_inicio && unViajePeriodica.hora.strftime('%H:%M') == 
                                                            self.hora_inicio.strftime('%H:%M')
          return true
        end
      end
    end
    return false
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
    if self.periodics
      cole = self.periodics
      cole.each do |periodica|
        cole.delete(periodica)
        if cole.detect{|f| f.fecha == periodica.fecha && f.hora == periodica.hora }
          errors.add("Dos fechas y horas, ", 'no pueden ser iguales')
        end
        cole << periodica
      end
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
  			errors.add("La fecha y hora defeben ser ", 'posteriores a ahora.')
  	end
  end
  
  def viajePostulado_a_la_misma_hora
  	if self.piloto.viajesPostulado.detect{ |t| t.id != self.id and t.fecha_inicio == self.fecha_inicio and 
  											t.hora_inicio == self.hora_inicio }
  		errors.add("Estas postulado a un viaje,", ' a la misma hora, el mismo día que éste.')
  	end
  end
  
  def viajePiloto_a_la_misma_hora
  	if self.piloto.viajesPiloto.detect{ |t| t.id != self.id and t.fecha_inicio == self.fecha_inicio and 
  											t.hora_inicio == self.hora_inicio }
  		errors.add("Tienes un viaje pendiente,", ' a la misma hora, el mismo día que éste.')
  	end
  end

  def saldo_en_contra
  	if self.piloto.account.deuda? or self.piloto.account.saldo != 0
  		errors.add("No puedes crear un viaje ", 'si tienes deuda pendiente')
  	end
  end

  def vehiculo_no_en_viaje
  	if Trip.where(:vehicle_id => self.vehicle_id).detect{ |t| t.id != self.id and 
  				t.fecha_inicio == self.fecha_inicio and t.hora_inicio == self.hora_inicio }
  		errors.add("El vehículo elegido", 
  					' tiene un viaje asignado a la misma hora, el mismo día')
  	end
  end

  def calificaciones_pendientes
  	if self.piloto.calif_creadas.detect{ |c| !c.realizada }
  		errors.add("No puedes crear un viaje, ", 'si tienes calificaciones pendientes')
  	end
  end

  def costo_mayor_a_cero
    if self.costo and self.costo <= 0
      errors.add("El costo", 'debe ser mayor a (0) cero')
    end
  end

end