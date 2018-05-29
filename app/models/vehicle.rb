class Vehicle < ApplicationRecord
  has_many :owners
  has_many :users, through: :owners


  	validate :existe, on: create
	validates :patente, format: { with: /([a-zA-Z]{3}[0-9]{3}|[a-z]{2}[0-9]{3}[a-zA-Z]{2})/, 
									message: "Patente incorrecta"}
	validates :modelo, numericality: {only_integer: true, message: 'Año: Sólo numeros
										 - Obligatorio.'}
	validates :marca, format: { with: /\A[\sa-zA-Z]+\z/, message: "Marca: Solo letras - Obligatorio"}

	validates :cantidad_asientos, numericality: {only_integer: true, message: 'Cantidad de 
													asientos: Solo numeros - Obligatorio.'}
	
	validates :color, format: { with: /\A[a-zA-Z]+\z/, message: "Color: Solo letras - Obligatorio"}
	validates :sub_marca, format: { with: /\A[\sa-zA-Z0-9]+\z/, message: "Modelo: Solo letras y numeros - Obligatorio"}
	
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
			errors.add("nada", 'Debes elegir un tipo de vehículo')
		end
	end
end
