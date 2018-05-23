class VehiclesController < ApplicationController

	def new
		@vehicle = Vehicle.new
	end

	def create
		#@user = User.find(params[current_user])
		@vehicle = current_user.vehicles.new(parametros)
		if @vehicle.save
			redirect_to current_user
		else
			render :new
		end
	end

private
	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo)
	end

end