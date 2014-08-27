class QuestionsController < ApplicationController
  before_action :authenticate_user!

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
    logged_in_user = current_student ? current_student : current_teacher
    @question = Question.create(question_params.merge({askable: logged_in_user}))
    redirect_to questions_path
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
    @answer = Answer.new
    impressionist(@question, nil, { unique: [:session_hash] })
  end

  private
  
  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end
  private 

  def question_liked_by(question,user)
    question.liked_by(user)
  end

  def question_disliked_by(question,user)
    question.disliked_by(user)
  end

  def liked_by
    liked_by = current_student.present? ? current_student : current_teacher
  end
  def logged_in_user
      logged_in_user = current_student ? current_student : current_teacher
  end

  def authenticate_user!
    if logged_in_user.nil?
      redirect_to root_path
    end
  end
end
