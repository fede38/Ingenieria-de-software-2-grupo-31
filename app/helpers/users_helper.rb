module UsersHelper

  def formato_fecha
    f = @user.fecha_nacimiento
    f.day.to_s+'/'+f.month.to_s+'/'+f.year.to_s
  end

  def username
    @user.email.split('@').first
  end

  def username2(usuario)
    usuario.email.split('@').first	
  end
end
