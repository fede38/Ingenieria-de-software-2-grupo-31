class UsersController < ApplicationController
#  before_action :logged_in?, only: [:index, :edit, :update]
#  before_action :correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end
end
