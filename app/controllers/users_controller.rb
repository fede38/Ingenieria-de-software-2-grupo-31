class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def pagarTodoSaldo
    @user = User.find(params[:id])
    if @user.account.saldo >= @user.account.deuda
      cuenta = @user.account
      cuenta.update_attribute(:saldo, (cuenta.saldo - cuenta.deuda).round(2))
      pagadoTotal(@user, cuenta)
    else
      flash[:danger] = "No se tiene suficiente saldo para pagar la deuda completa."
    end
    redirect_to :back
  end

  def pagar
    @tipo = params[:tipo]
    @viaje = Trip.find(params[:idT])
    @user = User.find(params[:id])
    viajeEsp = Embarkment.find_by(user: @user, trip: @viaje)
    @deuda = (params[:tipo] == 'p') ? (viaje.costo * 0.05).round(2) : (viajeEsp.deuda).round(2)
  end

  def pagarTodoTarjeta
    @user = User.find(params[:id])
    cuenta = @user.account
    pagadoTotal(@user, cuenta)
    redirect_to :back
  end

  def pagarViajeSaldo
    viaje = Trip.find(params[:idT])
    user = User.find(params[:id])
    cuenta = user.account
    viajeEsp = Embarkment.find_by(user: user, trip: viaje)
    cantPagar = (params[:tipo] == 'p') ? (viaje.costo * 0.05).round(2) : (viajeEsp.deuda).round(2)
    if cuenta.saldo >= cantPagar
      cuenta.update_attributes(saldo: (cuenta.saldo - cantPagar).round(2),
                deuda: (cuenta.deuda - cantPagar).round(2))
      if params[:tipo] == 'p'
        viaje.update_attribute(:pagado, true)
      else
        viajeEsp.update_attribute(:deuda, 0)
        cuentaPiloto = viaje.piloto.account
        cuentaPiloto.update_attribute(:saldo, (cuentaPiloto.saldo + cantPagar).round(2))
      end
    else
      flash[:danger] = "No se tiene suficiente saldo para pagar la deuda."
    end
    redirect_to :back
  end

  def pagarViajeTarjeta
    viaje = Trip.find(params[:idT])
    user = User.find(params[:id])
    cuenta = user.account
    viajeEsp = Embarkment.find_by(user: user, trip: viaje)
    cantPagar = (params[:tipo] == 'p') ? (viaje.costo * 0.05).round(2) : (viajeEsp.deuda).round(2)
    cuenta.update_attributes(deuda: (cuenta.deuda - cantPagar).round(2))
    if params[:tipo] == 'p'
      viaje.update_attribute(:pagado, true)
    else
      viajeEsp.update_attribute(:deuda, 0)
      cuentaPiloto = viaje.piloto.account
      cuentaPiloto.update_attribute(:saldo, (cuentaPiloto.saldo + cantPagar).round(2))
    end
    redirect_to :back
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
        cuentaP.update_attribute(:saldo, (cuentaP.saldo + dc.deuda).round(2))
        dc.update_attribute(:deuda, 0)
      end
    end

    def correct_user
      redirect_to root_path unless params[:id] == current_user.id
    end
end
