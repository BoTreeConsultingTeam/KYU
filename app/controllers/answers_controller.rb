class AnswersController < ApplicationController
  
  def new
    @answer = Answer.new
    question_id = @answer.question
  end

  def create
    logged_in_user = current_student ? current_student : current_teacher
    @answer = Answer.create(answer_params.merge({answerable: logged_in_user}))
    redirect_to questions_path
  end

  private

  def answer_params
    params.require(:answer).permit(:content,:question_id, :user_id)
  end
end
