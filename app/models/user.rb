class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, :default_url => 'missing_user.png'
  validates_attachment_content_type :avatar, :content_type => ["image/jpg",
                                    "image/jpeg", "image/png", "image/gif"]
  has_many :owner
  has_many :vehicles, through: :owner

  belongs_to :trip, optional: true, foreign_key: 'viaje_id'
  has_many :embarkment
  has_many :trips, through: :embarkment

  validates :nombre, :apellido, length: {maximum: 50}
  validates :nombre, :apellido, :fecha_nacimiento, presence: true

  validate :mayor_de_18
  validate :menor_de_117
  validate :tarjeta_correcta
  validate :solo_numeros

  def tarjeta_correcta
    if ((self.tarjeta) && (!self.tarjeta.empty?))
      if(self.tarjeta.length != 16)
        errors.add("El formato de la tarjeta de credito ", 'es incorrecto.')
      end
    end
  end

  def solo_numeros
    if self.tarjeta
      if !self.solonumeros?(self.tarjeta)
        errors.add("La tarjeta no puede ", 'contener caracteres.')
      end
    end
  end

  def mayor_de_18
    if self.fecha_nacimiento != nil
      if self.fecha_nacimiento > 18.years.ago.to_date
        errors.add("Debes tener mas ", 'de 18 años para usar esta página.')
      end
    end
  end

  def menor_de_117
    if self.fecha_nacimiento
      if self.fecha_nacimiento < 117.years.ago.to_date
        errors.add("Estas muy viejo ", 'para usar esta app.')
      end
    end
  end

  def borrar
    update_attribute(:eliminado, true)
  end

  def active_for_authentication?
    super && !eliminado
  end

  def inactive_message
    !eliminado ? super : :noexiste
  end

  protected
    def solonumeros?(string)
      string.scan(/\D/).empty?
    end
end
