class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => {:small => "100x100"},
                             :default_url => 'missing_user.png'

  # Falta configurar envio de mail en inscripcion

  validates :password, length: {maximum: 25}
  validates :nombre, :apellido, length: {maximum: 50}
  validates :nombre, :apellido, :fecha_nacimiento, presence: true

  validate :mayor_de_18

  def mayor_de_18
    if self.fecha_nacimiento > 18.years.ago.to_date
      errors.add("Debes tener mas ", 'de 18 años para usar esta página.')
    end
  end
end
