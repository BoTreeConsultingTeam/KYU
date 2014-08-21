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

  def vote
    value = params[:type] == "up" ? 1 : -1
   
    @question = Question.find(params[:id])
    if value==1
      @question.liked_by current_student
    elsif value==-1
      @question.disliked_by current_student
    end

    redirect_to questions_path
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

end
