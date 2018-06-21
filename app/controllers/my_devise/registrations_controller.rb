class MyDevise::RegistrationsController < Devise::RegistrationsController
  def create
    super do
      resource.account = Account.create
    end
  end

  def destroy
    if deuda?(resource) || calificacionesPendientes?(resource) ||
       viajesPendientes?(resource)
      flash[:danger] = []
      if deuda?(resource)
        flash[:danger] = 'No se puede tener deuda.'
      end
      if calificacionesPendientes?(resource)
        if !flash[:danger].empty?
          flash[:danger][-1] = ', '
          flash[:danger] << 'calificaciones pendientes.'
        else
          flash[:danger] = 'No puede haber calificaciones pendientes.'
        end
      end
      if viajesPendientes?(resource)
        if !flash[:danger].empty?
          flash[:danger][-1] = ' o '
          flash[:danger] << ' tener o estar aceptado en viajes pendientes.'
        else
          flash[:danger] = 'No se puede tener o estar aceptado en viajes pendientes.'
        end
      end
      flash[:danger][-1] = ' '
      flash[:danger] << 'para eliminar tu cuenta.'
      redirect_to :back
    else
      Embarkment.joins(:trip).where(estado: 'p', user_id: resource, "trips.activo": true).each do |e|
        User.find(resource).viajesPostulado.delete(e.trip)
      end
      resource.borrar
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      set_flash_message :notice, :destroyed
      yield resource if block_given?
      respond_with_navigational(resource){
        redirect_to after_sign_out_path_for(resource_name)
      }
    end
  end

  protected
    def after_update_path_for(resource)
      user_path(resource)
    end
end
