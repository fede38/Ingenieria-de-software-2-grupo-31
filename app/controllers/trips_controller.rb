class TripsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show]

	def index
		if user_signed_in?
			@user = current_user
		end
		@trips = Trip.all
	end

	def new
		@trip = Trip.new
		@user= User.find(params[:user_id])
	end

	def show
		@user= User.find(params[:user_id])
		@trip = Trip.find(params[:id])
	end

	def create
		@trip = Trip.new(parametros_viaje)
		@user= User.find(params[:user_id])
		#@trip.vehicle_id= Vehicle.find_by(:patente => parametros_viaje[:vehicle_id])
		@trip.user_id = @user.id
		if @trip.save
			#cobrar el 5% del valor del viaje
			current_user.viajesPiloto << @trip
			redirect_to root_path
		else
			render 'new'
		end
	end


	def aceptar
	end

	def rechazar

	end

	private

		def parametros_viaje
			params.require(:trip).permit(:fecha_inicio,:hora_inicio,:costo,:destino,
										:descripcion,:vehicle_id,:user_id)
		end

end

