class TripsController < ApplicationController
	skip_before_action :authenticate_user!, only: [:index, :show]

	def index
		if user_signed_in?
			@user = current_user
		end
    @q = Trip.ransack(params[:q])
    @trips = @q.result.where(activo: true).paginate(page: params[:page], per_page: 5)
  end

  	def edit
  		@trip = Trip.find(params[:id])
  		@user = @trip.piloto
  	end

  	def update
  		@trip = Trip.find(params[:id])
      	@user = @trip.piloto
  		if Embarkment.where('trip_id = ? AND estado != ?', @trip.id, 'r').present?
      	flash[:danger] = "No se pudo modificar el viaje. Para modificar el viaje, no puede haber postulantes o copilotos."
      	redirect_to :back
	  	elsif @trip.update(parametros_viaje)
        	redirect_to "/users/#{current_user.id}/showMisViajes"
  			flash[:success] = 'Viaje modificado existosamente.'
		else
			render 'edit'
		end
  	end


	def new
		@trip = Trip.new
		@user= User.find(params[:user_id])
	end

	def show
		@user= User.find(params[:user_id])
		@trip = Trip.find(params[:id])
 		@question = Question.new
 	end

	def showMisViajes
		@user = User.find(params[:id])
	    act_ord = Trip.where(piloto: @user, activo: true).reorder(:fecha_inicio, :hora_inicio)
	    @creado_activo = act_ord.paginate(page: params[:act_page], per_page: 5)
	    q = Embarkment.where(user_id: @user, estado: 'a').select(:trip_id)
	    re = Trip.where(activo: false, piloto: @user).or(Trip.where(activo: false, id: q))
	    rea_ord = re.order(:fecha_inicio, :hora_inicio)
	    @realizado = rea_ord.paginate(page: params[:rea_page], per_page: 5)
   end

	def create
		@trip = Trip.new(parametros_viaje)
		@user= User.find(params[:user_id])
		@trip.user_id = @user.id
		if @trip.save
			current_user.viajesPiloto << @trip
			redirect_to root_path
			flash[:success] = 'Viaje creado existosamente!'
		else
			render 'new'
		end
	end

	def destroy
		@user = User.find(params[:user_id])
		@trip = Trip.find(params[:id])

		fecha = Time.now.year.to_s+'-'+Time.now.month.to_s+'-'+Time.now.day.to_s
		hora = Time.now.hour.to_s+':'+Time.now.min.to_s
 		Embarkment.where(trip_id: @trip.id).each do |rel|
 			if rel.estado == 'a'
 				cal = Score.create(calificado: @trip.piloto, realizada: true,
			                 tipo_calificacion: 'p', calificacion: -1,
			                 descripcion: 'Cancelo un viaje con copilotos aceptados',
			                 fecha: fecha, hora: hora)
				calificar(@trip.piloto, cal)
				TripMailer.sendMail(@trip, 'x', User.find(rel.user_id)).deliver
				@trip.postulantes.delete(rel.user_id)
			elsif rel.estado != 'r'
				TripMailer.sendMail(@trip, 'r', User.find(rel.user_id)).deliver
				@trip.postulantes.delete(rel.user_id)
			end
		end
    	@user.account.update_attribute(:deuda, ((@trip.costo * 0.05)+@user.account.deuda))
		Trip.delete(@trip.id)
		flash[:success] = 'Viaje cancelado existosamente.'
		redirect_to "/users/#{@user.id}/showMisViajes"
	end

	def postularse
		usuario = current_user
		viaje = Trip.find(params[:id])
		if deuda?(usuario) || calificacionesPendientes?(usuario)
      		flash[:danger] = []
      		if deuda?(usuario)
        		flash[:danger] = 'No se puede tener deuda.'
	      	end
	      	if calificacionesPendientes?(usuario)
		        if !flash[:danger].empty?
		          flash[:danger][-1] = ' o '
		          flash[:danger] << 'calificaciones pendientes.'
		        else
		          flash[:danger] = 'No puede haber calificaciones pendientes.'
		        end
      	end
      	flash[:danger][-1] = ' '
      	flash[:danger] << 'para poder postularse a un viaje.'
		redirect_to :back
		else
			viaje.postulantes << usuario
			flash[:success] = 'Te has postulado correctamente.'
			redirect_to user_trip_path(viaje.piloto, viaje)
		end
	end

	def aceptar
		usuario = User.find(params[:idU])
		viaje = Trip.find(params[:idT])
		rel = Embarkment.find_by(user_id: usuario.id,
				  									 trip_id: viaje.id)
		if viaje.cantidad_asientos_ocupados == viaje.vehicle.cantidad_asientos ||
			 mismaHora?(usuario, viaje)
			flash[:danger] = []
      if viaje.cantidad_asientos_ocupados == viaje.vehicle.cantidad_asientos
        flash[:danger] = 'No hay mas espacio en el vehiculo.'
      end
      if mismaHora?(usuario, viaje)
        if !flash[:danger].empty?
          flash[:danger][-1] = ' y '
          flash[:danger] << 'el usuario ya ha sido aceptado en otro viaje a la misma hora.'
        else
          flash[:danger] = 'El usuario ya ha sido aceptado en otro viaje a la misma hora.'
        end
      end
		else
			TripMailer.sendMail(viaje, 'a', usuario).deliver
			rel.update_attribute(:estado, 'a')
			viaje.increment!(:cantidad_asientos_ocupados, 1)
			rel.touch
		end
		redirect_to :back
	end

	#embarkment estado = 'p' pendiente; 'r' rechazado; 'a' aceptado

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
		fecha = Time.now.year.to_s+'-'+Time.now.month.to_s+'-'+Time.now.day.to_s
		hora = Time.now.hour.to_s+':'+Time.now.min.to_s
		cal = Score.create(calificado: viaje.piloto, realizada: true,
			                 tipo_calificacion: 'p', calificacion: -1,
			                 descripcion: 'Elimino a un usuario ya aceptado.',
			                 fecha: fecha, hora: hora)
		calificar(viaje.piloto, cal)
		TripMailer.sendMail(viaje, 'e', usuario).deliver
		redirect_to :back
	end

	def cancelarPostulacion
		usuario = User.find(params[:idU])
		viaje = Trip.find(params[:idT])
		if Embarkment.find_by(user_id: usuario.id, trip_id: viaje.id).estado == 'a'
			TripMailer.sendMail(viaje, 'c', viaje.piloto).deliver
			fecha = Time.now.year.to_s+'-'+Time.now.month.to_s+'-'+Time.now.day.to_s
			hora = Time.now.hour.to_s+':'+Time.now.min.to_s
			cal = Score.create(calificado: usuario, realizada: true,
			                 tipo_calificacion: 'c', calificacion: -1,
			                 descripcion: 'Cancelo la postulación a un viaje en el que ya habia sido aceptado.',
			                 fecha: fecha, hora: hora)
			calificar(usuario, cal)
			viaje.decrement!(:cantidad_asientos_ocupados, 1)
		end
		flash[:success] = 'Te has dado de baja del viaje correctamente'
		viaje.postulantes.delete(usuario)
		redirect_to :back
	end

private

	def parametros_viaje
		params.require(:trip).permit(:fecha_inicio, :hora_inicio, :costo, :origen,
										:destino, :descripcion, :vehicle_id, :user_id)
	end

end
