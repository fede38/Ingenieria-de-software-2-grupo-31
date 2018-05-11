class UsersController < ApplicationController
  before_action :correct_user, only: [:edit, :update, :destroy]

  def show
    @user = User.find(params[:id])
  end

  private
    def correct_user
      redirect_to root_path unless params[:id] == current_user.id
    end
end
