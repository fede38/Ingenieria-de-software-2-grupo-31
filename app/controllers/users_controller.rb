class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def pagarTodoSaldo
    @user = User.find(params[:id])
    if @user.account.saldo >= @user.account.deuda
      cuenta = @user.account
      cuenta.update_attribute(:saldo, cuenta.saldo - cuenta.deuda)
      pagadoTotal(@user, cuenta)
    else
      flash[:danger] = "No se tiene suficiente saldo para pagar la deuda completa."
    end
    redirect_to :back
  end

  def pagarTodoTarjeta
    @user = User.find(params[:id])
    cuenta = @user.account
    pagadoTotal(@user, cuenta)
    redirect_to :back
  end

  def pagarViajeSaldo
  end

  def pagarViajeTarjeta
  end

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
    def pagadoTotal(user, cuenta)
      deuda_piloto = Trip.where(piloto: user, pagado: false, activo: false)
      deuda_copiloto = Embarkment.where(user_id: user, estado: 'a').where.not(deuda: 0)
      cuenta.update_attribute(:deuda, 0)
      deuda_piloto.each do |dp|
        dp.update_attribute(:pagado, true)
      end
      deuda_copiloto.each do |dc|
        cuentaP = dc.trip.piloto.account
        cuentaP.update_attribute(:saldo, cuentaP.saldo + dc.deuda)
        dc.update_attribute(:deuda, 0)
      end
    end

    def correct_user
      redirect_to root_path unless params[:id] == current_user.id
    end
end
