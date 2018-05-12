class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_attached_file :avatar, :styles => {:small => "100x100"},
                             :default_url => 'missing_user.png'

  # Falta configurar envio de mail en inscripcion

end
