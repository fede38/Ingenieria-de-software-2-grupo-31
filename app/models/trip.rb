class Trip < ApplicationRecord
  default_scope { order(origen: :asc, destino: :asc) }

  belongs_to :piloto, class_name: 'User', foreign_key: 'user_id'
  belongs_to :vehicle

  has_many :embarkment
  has_many :postulantes, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'

  validates :origen, :destino, :vehicle_id, :costo, :fecha_inicio, :hora_inicio, presence: true

  validate :fecha_mayor_a_hoy
  validate :hora_mayor_a_ahora

  def fecha_mayor_a_hoy
  	if self.fecha_inicio and self.fecha_inicio.past?
  		errors.add("La fecha de inicio debe ser ", 'posterior a hoy')
  		end
  end

  def hora_mayor_a_ahora
  	if self.fecha_inicio and self.fecha_inicio == Date.today and self.hora_inicio.past?
  			errors.add("La fecha y hora deben ser ", 'posteriores a ahora')
  	end
  end

end
