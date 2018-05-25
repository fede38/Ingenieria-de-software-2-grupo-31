class Vehicle < ApplicationRecord
  has_many :owners
  has_many :users, through: :owners


  	validate :existe
	validates :patente, format: { with: /([a-zA-Z]{3}[0-9]{3}|[a-z]{2}[0-9]{3}[a-zA-Z]{2})/, 
									message: "Patente incorrecta"}
	validates :modelo, format: { with: /[\sa-zA-Z0-9]/, message: "Modelo: Solo numeros y letras
									- Obligatorio"}
	validates :marca, format: { with: /\A[a-zA-Z]+\z/, message: "Marca: Solo letras - Obligatorio"}

	validates :cantidad_asientos, numericality: {only_integer: true, message: 'Cantidad de 
													asientos: Solo numeros - Obligatorio.'}
	
	validates :color, format: { with: /\A[a-zA-Z]+\z/, message: "Color: Solo letras - Obligatorio"}
	
	validates :tipo, inclusion: { in: %w(Moto Auto Pick-up Autobus Camion),
									message: "Tipo: Debes elegir Moto, Auto, Pick-up,
									Autobus, o Camion - Obligatorio"}

	def existe
		if Vehicle.exists?(:patente => self.patente)
			errors.add("", 
					 'La patente ya está registrada. Si compartes el vehiculo con otro usuario, 
					 prueba la opción vehículo compartido.')
		end
	end
end
