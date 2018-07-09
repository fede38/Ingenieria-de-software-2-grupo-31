class QuestionsController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @question = Question.new(parametros)
    if @question.save
      @question.update_attribute(:comentador, current_user)
      @question.update_attribute(:trip, @trip)
    else
      flash[:danger] = "No se pueden hacer preguntas vacias."
    end
    redirect_to :back
  end

  private
    def parametros
      params.require(:question).permit(:pregunta)
    end
end
