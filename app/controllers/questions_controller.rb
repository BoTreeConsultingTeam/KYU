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

  def create
    @question = Question.create(question_params)
    redirect_to root_path
  end

  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end

end
