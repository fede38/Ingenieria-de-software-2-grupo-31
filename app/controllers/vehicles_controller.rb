class VehiclesController < ApplicationController

	def new
		@vehicle = Vehicle.new
	end

	def create
		@vehicle = Vehicle.new(parametros)
		if @vehicle.save
			redirect_to current_user
		else
			render "/edit"
		end
	end

private
	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo)
	end

end