class ScoresController < ApplicationController
	def showCalifARealizar
    @user = User.find(params[:id])
	end

	def showCalificaciones
		@user = User.find(params[:id])
		@calification = Score.where(calificado: @user, realizada: true).order(fecha: :desc, hora: :desc)
	end
end
