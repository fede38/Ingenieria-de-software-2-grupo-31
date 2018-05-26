class VehiclesController < ApplicationController

	def new
		@vehicle = Vehicle.new
	end

	def create
		@vehicle = Vehicle.new(parametros)
		@user = User.find(params[:user_id])
		if Vehicle.exists?(:patente => @vehicle.patente)
			@user.vehicles << Vehicle.where(patente: @vehicle.patente).take
			redirect_to current_user
		else
			if @vehicle.save
				current_user.vehicles << @vehicle
				redirect_to current_user
			else
				render 'new'
			end
		end
	end

	def index
		@user = User.find(params[:user_id])
		@vehicle = @user.vehicles
	end

private
	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo)
	end
 end
