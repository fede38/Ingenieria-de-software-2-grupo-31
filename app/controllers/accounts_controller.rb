class AccountsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @cuenta = @user.account
    @deuda_piloto = Trip.where(piloto: @user, pagado: false, activo: false)
    @deuda_copiloto = Embarkment.where(user_id: @user, estado: 'a').where.not(deuda: 0)
  end
end
