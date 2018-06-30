class AccountsController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @cuenta = @user.account
  end
end
