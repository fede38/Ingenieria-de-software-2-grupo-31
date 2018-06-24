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
    if self.fecha_inicio and self.fecha_inicio < Date.today
      errors.add("La fecha de inicio debe ser hoy o ", 'posterior a hoy.')
      end
  end

  def hora_mayor_a_ahora
    hora = Time.now.hour.to_s + ':' + Time.now.min.to_s
    hora_viaje = self.hora_inicio.hour.to_s + ':' + self.hora_inicio.min.to_s
    if (self.fecha_inicio == Date.today) and (hora_viaje < hora)
        errors.add("La fecha y hora deben ser ", 'posteriores a ahora.')
    end
  end

end
