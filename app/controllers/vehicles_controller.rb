class VehiclesController < ApplicationController

	def new
		@vehicle = Vehicle.new
	end

	def create
		@vehicle = Vehicle.new(parametros)
		if @vehicle.save
			current_user.vehicles << @vehicle
			redirect_to current_user
		else
			render 'new'
		end
	end

	def index
		@vehicle = User.find(params[:user_id]).vehicles
	end

private
	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo)
	end

end
