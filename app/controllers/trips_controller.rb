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
		usuario = User.find(params[:idU])
		viaje = Trip.find(params[:idT])
		rel = Embarkment.find_by(user_id: usuario.id,
				  									 trip_id: viaje.id)
		if viaje.cantidad_asientos_ocupados < viaje.vehicle.cantidad_asientos
			TripMailer.sendMail(viaje, 'a', usuario).deliver
			rel.update_attribute(:estado, 'a')
			viaje.increment!(:cantidad_asientos_ocupados, 1)
			rel.touch
		else
			flash[:danger] = "No hay asientos disponibles en el auto, no se pueden aceptar mas postulantes."
		end
		redirect_to :back
	end

	def rechazar
		usuario = User.find(params[:idU])
		viaje = Trip.find(params[:idT])
		rel = Embarkment.find_by(user_id: usuario.id,
				  									 trip_id: viaje.id)
		rel.update_attribute(:estado, 'r')
		rel.touch
		TripMailer.sendMail(viaje, 'r', usuario).deliver
		redirect_to :back
	end

	def eliminar
		usuario = User.find(params[:idU])
		viaje = Trip.find(params[:idT])
		viaje.postulantes.delete(usuario)
		viaje.decrement!(:cantidad_asientos_ocupados, 1)
		calificarNegativamente(viaje.piloto, 'piloto')
		TripMailer.sendMail(viaje, 'e', usuario).deliver
		redirect_to :back
	end

private

	def parametros_viaje
		params.require(:trip).permit(:fecha_inicio,:hora_inicio,:costo,:destino,
									:descripcion,:vehicle_id,:user_id)
	end

end
