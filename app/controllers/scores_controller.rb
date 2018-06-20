class ScoresController < ApplicationController
	def showCalifARealizar
	end

	def showCalificaciones
		@user= User.find(params[:user_id])
		@calification = Score.where(calificado: @user, realizada: true).order(fecha: :desc, hora: :desc)
	end
end