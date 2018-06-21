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
		@score.update_attributes(realizada: true, fecha: fecha, hora: hora,
			calificacion: params[:score][:calificacion], descripcion: params[:score][:descripcion])
		calificar(@score.calificado, @score)
		redirect_to calificaciones_pendientes_user_path(current_user)
	end

	def showCalifARealizar
		@user = User.find(params[:id])
		@calification = Score.where(creador: @user, realizada: false).order(fecha: :desc, hora: :desc)
	end

	def showCalificaciones
		@user= User.find(params[:id])
		@calif_piloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'p').order(fecha: :desc, hora: :desc)
		@calif_copiloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'c').order(fecha: :desc, hora: :desc)
	end

	private

		def parametros
			params.permit!
		end

end
