class AccountsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @cuenta = @user.account
    r = Trip.where(activo: false).select(:trip_id)
    @deudas = Embarkment.where(user_id: @user, estado: 'a', trip_id: r)
  end
end
