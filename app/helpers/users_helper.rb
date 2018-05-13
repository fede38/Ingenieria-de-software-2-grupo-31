module UsersHelper

  def formato_fecha
    f = @user.fecha_nacimiento
    f.day.to_s+'/'+f.month.to_s+'/'+f.year.to_s
  end

end
