class MyDevise::RegistrationsController < Devise::RegistrationsController
  def create
    super do
      resource.account = Account.create
    end
  end

  def destroy
    resource.borrar
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){
      redirect_to after_sign_out_path_for(resource_name)
    }
  end

  protected
    def after_update_path_for(resource)
      user_path(resource)
    end
end
