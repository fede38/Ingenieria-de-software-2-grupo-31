class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    if params[:id]
      @user = User.find(params[:id])
    else
      @user = current_user
    end
  end

  private
    def correct_user
      redirect_to root_path unless params[:id] == current_user.id
    end
end
