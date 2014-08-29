class AnswersController < ApplicationController
  before_action :authenticate_user!

  def new
    @answer = Answer.new
    @question = Question.find(params[:question_id])
    question_id = @answer.question

  end

  def create
    logged_in_user = current_student ? current_student : current_teacher
    @answer = Answer.create(answer_params.merge({answerable: logged_in_user}))
    @question = Question.find(params[:answer][:question_id])
    redirect_to questions_path(@question)
  end
  
  def edit
    @question = Question.find(params[:question_id])
    @answer = Answer.find(params[:id])
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = Question.find(params[:answer][:question_id])
    redirect_to question_path(@question)
  end

  def destroy
    @answer = Answer.find(params[:id]).delete
    @question = Question.find(params[:question_id])
    @answer.destroy
    redirect_to question_path(@question)
  end

  def upvote
    @answer = Answer.find(params[:id])
    answer_liked_by(@answer,liked_by)
    redirect_to :back
  end

  def downvote
    @answer = Answer.find(params[:id])
    answer_disliked_by(@answer,liked_by)
    redirect_to :back
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

  def answer_liked_by(answer,user)
    answer.liked_by(user)
  end

  def answer_disliked_by(answer,user)
    answer.disliked_by(user)
  end
end
