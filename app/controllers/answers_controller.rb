class AnswersController < ApplicationController
  
  def new
    @answer = Answer.new
    question_id = @answer.question
  end

  def create
    @answer = Answer.create(answer_params)    
    redirect_to questions_path
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

  def liked_by
    liked_by = current_student.present? ? current_student : current_teacher
  end

end
