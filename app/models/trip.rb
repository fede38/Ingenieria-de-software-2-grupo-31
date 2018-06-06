class Trip < ApplicationRecord
  has_one :piloto, class_name: 'User', foreign_key: 'viaje_id'
  has_one :auto, class_name: 'Vehicle', foreign_key: 'viaje_id'
  has_many :embarkment
  has_many :pasajeros, source: :user, through: :embarkment, class_name: 'User', foreign_key: 'user_id'
end
