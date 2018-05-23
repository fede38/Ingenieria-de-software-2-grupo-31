class VehiclesController < ApplicationController

	def new
		@vehicle = Vehicle.new
	end

	def create
		@vehicles = Vehicle.new(parametros)
		if @vehicles.save
			current_user.vehicles << @vehicles
			redirect_to current_user
		else
			render :new
		end
	end

	def index
		@vehicles = User.find(params[:user_id]).vehicles
	end

private
	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo)
	end

end
