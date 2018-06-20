class ScoresController < ApplicationController
	
	def showCalifARealizar
		@user = User.find(params[:user_id])
		@calification = Score.where(creador: @user, realizada: false).order(fecha: :desc, hora: :desc)
	end

	def showCalificaciones
		@user= User.find(params[:user_id])
		@calif_piloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'p').order(fecha: :desc, hora: :desc)
		@calif_copiloto = Score.where(calificado: @user, realizada: true, tipo_calificacion: 'c').order(fecha: :desc, hora: :desc)
	end
end