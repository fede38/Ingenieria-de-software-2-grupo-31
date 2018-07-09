class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
      q = Embarkment.where(user_id: @user, estado: 'a').select(:trip_id)
      r = Trip.where(activo: false, piloto: @user).or(Trip.where(activo: false, id: q))
      @realizado = r.order(:fecha_inicio, :hora_inicio).first(5)
  end

  def postulaciones
    @user = current_user
    @postulaciones = Embarkment.where('user_id = ?', @user.id).order(updated_at: :desc)
  end

  private
    def correct_user
      redirect_to root_path unless params[:id] == current_user.id
    end
end
