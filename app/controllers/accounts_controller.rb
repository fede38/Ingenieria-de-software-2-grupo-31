class AccountsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @cuenta = @user.account
    r = Trip.where(activo: false).select(:trip_id)
    @deuda_piloto = Trip.where(piloto: @user, pagado: false, id: r)
    @deuda_copiloto = Embarkment.where(user_id: @user, estado: 'a', trip_id: r).where.not(deuda: 0)
  end
end
