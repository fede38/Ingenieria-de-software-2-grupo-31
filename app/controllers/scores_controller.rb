class ScoresController < ApplicationController

	def edit
		@user = current_user
		@score = @user.calif_creadas.find(params[:id])
	end

	def update
		@user = current_user
		@score = @user.calif_creadas.find(params[:id])
		fecha = Time.now.year.to_s+'-'+Time.now.month.to_s+'-'+Time.now.day.to_s
		hora = Time.now.hour.to_s+':'+Time.now.min.to_s
		if @score.update_attributes(realizada: true, fecha: fecha, hora: hora,
			calificacion: params[:score][:calificacion], descripcion: params[:score][:descripcion])
			calificar(@score.calificado, @score)
			redirect_to calificaciones_pendientes_user_path(current_user)
		else
			render 'edit'
		end
	end

	def showCalifARealizar
		@user = User.find(params[:id])
		@q = Score.where(creador: @user, realizada: false).reorder(fecha: :desc, hora: :desc)
		@calification = @q.result.paginate(page: params[:page], per_page: 15)
	end

	def showCalificaciones
		@user= User.find(params[:id])
		@calif_piloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'p').reorder(fecha: :desc, hora: :desc).paginate(page: params[:page], per_page: 8)
		@calif_copiloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'c').reorder(fecha: :desc, hora: :desc).paginate(page: params[:page], per_page: 8)
		 
	end

	private

		def parametros
			params.permit!
		end

end
