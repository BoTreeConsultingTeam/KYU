class QuestionsController < ApplicationController
   
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag]).page params[:page]
    elsif params[:time]
      if params[:time] == 'week'
        @questions = Question.recent_data_week.page params[:page]
      else
        @questions = Question.recent_data_month.page params[:page]
      end
    else
      @questions = Question.all_data.page params[:page]
    end
  end

  def new
    @question = Question.new
    @question.user_id = session[:id]
  end

  def create
    logged_in_user = current_student ? current_student : current_teacher
    @question = Question.create(question_params.merge({askable: logged_in_user}))
    redirect_to questions_path
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
    impressionist(@question, nil, { unique: [:session_hash] })
  end

  private
  
  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end

end
