class ContactFormsController < ApplicationController
  def new
    @user = current_user
    @contact_form = ContactForm.new
  end

  def create
    @user = current_user
    @contact_form = ContactForm.new(params[:contact_form])
    @contact_form.name = @user.nombre
    @contact_form.email = @user.email
    @contact_form.request = request
    if @contact_form.deliver
      flash.now[:notice] = 'Gracias por tu mensaje!'
    else
      flash[:danger] = 'El mensaje no puede estar vacio.'
      render :new
    end
  end
end
