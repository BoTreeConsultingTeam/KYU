class AnswersController < ApplicationController
  
  def new
    @answer = Answer.new
    question_id = @answer.question
  end

  def create
    @answer = Answer.create(answer_params)    
    redirect_to questions_path
  end
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy
    redirect_to :back
  end
  private

  def answer_params
    params.require(:answer).permit(:content,:question_id, :user_id)
  end
end
