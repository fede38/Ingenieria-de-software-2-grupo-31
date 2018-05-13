class User < ApplicationRecord
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => {:small => "100x100"},
                             :default_url => 'missing_user.png'
  validates_attachment_content_type :avatar, :content_type => ["image/jpg",
                                    "image/jpeg", "image/png", "image/gif"]


  # Falta configurar envio de mail en inscripcion

  validates :password, length: {maximum: 25}
  validates :nombre, :apellido, length: {maximum: 50}
  validates :nombre, :apellido, :fecha_nacimiento, presence: true

  validate :mayor_de_18
  validate :tarjeta_correcta
  validate :solo_numeros

  def tarjeta_correcta
    if self.tarjeta && self.codigo_seguridad
      if(self.tarjeta.length != 16)||(self.codigo_seguridad.length != 3)
        errors.add("El formato de la tarjeta de credito ", 'es incorrecto.')
      end
    end
  end

  def solo_numeros
    if !self.solonumeros?(self.tarjeta) ||
       !self.solonumeros?(self.codigo_seguridad)
      errors.add("La tarjeta no puede ", 'contener caracteres.')
    end
  end

  def mayor_de_18
    if self.fecha_nacimiento != nil
      if self.fecha_nacimiento > 18.years.ago.to_date
        errors.add("Debes tener mas ", 'de 18 años para usar esta página.')
      end
    end
  end

  protected
    def solonumeros?(string)
      string.scan(/\D/).empty?
    end
end
