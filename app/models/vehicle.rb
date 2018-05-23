class Vehicle < ApplicationRecord
	has_and_belongs_to_many :users


	validates :patente, format: { with: /([a-zA-Z]{3}[0-9]{3}|[a-z]{2}[0-9]{3}[a-zA-Z]{2})/, message: "Patente incorrecta"}
	validates :modelo, format: { with: /[\sa-zA-Z0-9]/, message: "Modelo: Solo numeros y letras"}
	validates :marca, format: { with: /\A[a-zA-Z]+\z/, message: "Marca: Solo letras"}
	validates :cantidad_asientos, numericality: {only_integer: true, message: 'Cantidad de asientos: Solo numeros.'}
	validates :color, format: { with: /\A[a-zA-Z]+\z/, message: "Color: Solo letras"}
	validates :tipo, inclusion: { in: %w(Moto Auto Pick-up Autobus Camion), 
								message: "Tipo: Debes elegir Moto, Auto, Pick-up, Autobus o Camion"
								}


end
