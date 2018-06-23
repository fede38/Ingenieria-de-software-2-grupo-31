class VehiclesController < ApplicationController
    before_action :correct_user, except: [:show, :index]

	def new
		@vehicle = Vehicle.new
	end

	def create
		@vehicle = Vehicle.new(parametros)
		@user = User.find(params[:user_id])
		if Vehicle.exists?(:patente => parametros[:patente])
			if @user.vehicles.exists?(:patente => parametros[:patente])
				@vehicle.errors.add("El vehiculo ", 'ya esta agregado.')
				render 'new'
			else
				@user.vehicles << Vehicle.find_by(patente: parametros[:patente])
				redirect_to user_vehicles_url
			end
		else
			if @vehicle.save
				current_user.vehicles << @vehicle
				redirect_to user_vehicles_url
			else
				render 'new'
			end
		end
	end

	def index
		@user = User.find(params[:user_id])
		@vehicle = @user.vehicles
	end

	def edit
		@user = User.find(params[:user_id])
		@vehicle = @user.vehicles.find(params[:id])
	end

	def update
		@user = User.find(params[:user_id])
		@vehicle = @user.vehicles.find(params[:id])
		if @vehicle.update_attributes(parametros)
			redirect_to user_vehicles_url
		else
			render 'edit'
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		@vehicle = @user.vehicles.find(params[:id])
		if Trip.where(piloto: @user, vehicle: @vehicle, activo: true).exists?
			flash[:danger] = "El vehiculo esta en un viaje activo propio y no puede ser eliminado"
		else
			@user.vehicles.delete(params[:id])
		end
		redirect_to user_vehicles_url
	end

private

	def parametros
		params.require(:vehicle).permit(:patente, :modelo, :marca, :cantidad_asientos, :color, :tipo, :sub_marca)
	end

	def correct_user
		@user = User.find(params[:user_id])
		redirect_to current_user unless @user == current_user
	end
end
