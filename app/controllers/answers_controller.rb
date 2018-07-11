class AnswersController < ApplicationController
  def create
    @trip = Trip.find(params[:trip_id])
    @question = Question.find(params[:question_id])
    @answer = Answer.new(parametros)
    if @answer.save
      QuestionMailer.sendMail(@trip, 'a', @question.comentador).deliver
      @answer.update_attribute(:question, @question)
    else
      flash[:danger] = "La respuesta debe tener texto.."
    end
    redirect_to :back
  end

  private
    def parametros
      params.require(:answer).permit(:respuesta)
    end

end
