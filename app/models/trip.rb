class Trip < ApplicationRecord
  has_one :user, class_name: 'Piloto'
  has_many :users, through: :users_trips
end
