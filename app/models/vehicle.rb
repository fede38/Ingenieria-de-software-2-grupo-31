class Vehicle < ApplicationRecord
  has_many :owners
  has_many :users, through: :owners

	validates :patente, format: { with: /[a-zA-Z0-9]+/, message: 'no es válida'},
																length: { maximum: 25}, presence: true
	validates :modelo, numericality: {only_integer: true}, presence: true
	validates :marca, format: { with: /\A[\sa-zA-Z]+\z/, message: 'no es válida'}, presence: true

	validates :cantidad_asientos, numericality: {only_integer: true, message: ': solo numeros,
													sin espacios'}, presence: true

	validates :color, format: { with: /\A[a-zA-Z]+\z/, message: ": solo letras"}, presence: true
	validates :sub_marca, format: { with: /\A[\sa-zA-Z0-9]+\z/, message: ": solo letras y
									numeros, sin espacios"}, presence: true

	validate :validacion_tipo

	def validacion_tipo
		if self.tipo == '--Elige el tipo--'
			errors.add("Debes elegir ", 'un tipo de vehículo')
		end
	end
end
