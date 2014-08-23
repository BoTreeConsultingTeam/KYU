class QuestionsController < ApplicationController
  
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end
  end

  def new
    @question = Question.new
    @question.user_id = session[:id]
  end

  def upvote
     @question = Question.find(params[:id])
     question_liked_by(@question,liked_by)
    redirect_to :back
  end

  def downvote
    @question = Question.find(params[:id])
    question_disliked_by(@question,liked_by)
    redirect_to :back
  end

  def create
    @question = Question.create(question_params)
    redirect_to questions_path
  end
  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
  end
  private
  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end
  private 

  def question_liked_by(question,user=nil)
    question.liked_by(user)
  end

  def question_disliked_by(question,user=nil)
    question.disliked_by(user)
  end

  def liked_by
    liked_by=  current_student.present? ? current_student : current_teacher
    return liked_by
  end
end
