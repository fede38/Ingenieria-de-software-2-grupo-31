class Trip < ApplicationRecord
  belongs_to :piloto, class_name: 'User', foreign_key: 'user_id'
  belongs_to :vehicle

  has_many :embarkment
  has_many :postulantes, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'
end
