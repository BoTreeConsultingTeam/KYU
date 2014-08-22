class QuestionsController < ApplicationController
  include QuestionsHelper
  def index
    if received_tag
      @questions = Question.tagged_with(received_tag).page params[:page]
    elsif received_time
      if received_time == 'week'
        @questions = Question.recent_data_week.page params[:page]
      else
        @questions = Question.recent_data_month.page params[:page]
      end
    else
      @questions = Question.all.page params[:page]
    end
  end

  def new
    @question = Question.new
    @question.user_id = session[:id]
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
