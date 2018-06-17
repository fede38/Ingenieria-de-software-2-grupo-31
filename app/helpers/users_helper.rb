module UsersHelper

  def username
    @user.email.split('@').first
  end

  def usernameOf(usuario)
    usuario.email.split('@').first
  end
end
