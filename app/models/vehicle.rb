class Vehicle < ApplicationRecord
  has_many :owners
  has_many :users, through: :owners


	validate :existe, on: create
	validates :patente, format: { with: /[a-zA-Z0-9]+/}, length: { maximum: 25}, presence: true
	validates :modelo, numericality: {only_integer: true}, presence: true
	validates :marca, format: { with: /\A[\sa-zA-Z]+\z/}, presence: true

	validates :cantidad_asientos, numericality: {only_integer: true, message: 'Solo numeros, 
													sin espacios - Obligatorio.'}, presence: true
	
	validates :color, format: { with: /\A[a-zA-Z]+\z/, message: "Color: Solo letras
								 - Obligatorio"}, presence: true
	validates :sub_marca, format: { with: /\A[\sa-zA-Z0-9]+\z/, message: "Solo letras y 
									numeros, sin espacios - Obligatorio"}, presence: true

	validate :validacion_tipo

	def existe
		if Vehicle.exists?(:patente => self.patente)
			errors.add("", 
					 'La patente ya está registrada. Si compartes el vehiculo con otro usuario, 
					 prueba la opción vehículo compartido.')
		end
	end

	def validacion_tipo
		if self.tipo == '--Elige el tipo--'
			errors.add("Tipo ", 'debes elegir un tipo de vehículo')
		end
	end
end