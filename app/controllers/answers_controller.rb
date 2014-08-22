class AnswersController < ApplicationController
  
  def new
    @answer = Answer.new
    question_id = @answer.question
  end

  def create
    @answer = Answer.create(answer_params)    
    redirect_to questions_path
  end

  def accept
    @answer=Answer.find(params[:id])
    @answer.flag = true
    @answer.save

    redirect_to question_path(@answer.question)
  end

  private

  def answer_params
    params.require(:answer).permit(:content,:question_id, :user_id)
  end
end
