class TripsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    if user_signed_in?
      @user = current_user
    end
    @trips = Trip.all
  end

end
