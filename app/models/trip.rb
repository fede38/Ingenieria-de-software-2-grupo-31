class Trip < ApplicationRecord
  has_one :piloto, class_name: 'User', foreign_key: 'viaje_id'
  has_many :embarkment
  has_many :users, through: :embarkment
end
