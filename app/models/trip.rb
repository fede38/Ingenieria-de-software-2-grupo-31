class Trip < ApplicationRecord
  default_scope { order(destino: :asc) }

  belongs_to :piloto, class_name: 'User', foreign_key: 'user_id'
  belongs_to :vehicle

  has_many :embarkment
  has_many :postulantes, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'

  validates :destino, :origen, :vehicle_id, :costo, :fecha_inicio, :hora_inicio, presence: true

  validate :fecha_mayor_a_hoy
  validate :hora_mayor_a_ahora
  #validate :saldo_en_contra
  validate :viajePostulado_a_la_misma_hora
  validate :viajePiloto_a_la_misma_hora

  def fecha_mayor_a_hoy
  	if self.fecha_inicio and self.fecha_inicio < Date.today
  		errors.add("La fecha de inicio debe ser hoy o ", 'posterior a hoy.')
  		end
  end

  def hora_mayor_a_ahora
  	if (self.fecha_inicio <=> Date.today) and (self.hora_inicio < Time.now - (3600)*3) 
  			errors.add("La fecha y hora deben ser ", 'posteriores a ahora.')
  	end
  end

  def viajePostulado_a_la_misma_hora
  	if self.piloto.viajesPostulado.all?{ |v| v.fecha_inicio == self.fecha_inicio and
  											 v.hora_inicio == self.hora_inicio }
  		errors.add("Estas postulado a un viaje,", ' a la misma hora que éste.')
  	end
  end
  
  def viajePiloto_a_la_misma_hora
  	if self.piloto.viajesPiloto.all?{ |v| v.fecha_inicio == self.fecha_inicio and 
  											v.hora_inicio == self.hora_inicio }
  		errors.add("Tienes un viaje pendiente,", ' a la misma hora que éste.')
  	end
  end
  #def saldo_en_contra
  #	if @user.account.deuda
  #		errors.add("No puedes crear un viaje ", 'si tienes deuda pendiete')
  #	end
  #end

end