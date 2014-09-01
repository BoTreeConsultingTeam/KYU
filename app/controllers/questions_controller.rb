class QuestionsController < ApplicationController
  before_action :user_signed_in?
    
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
    @question = Question.create(question_params.merge({askable: current_user}))
    redirect_to questions_path
  end

  def show
    @question = Question.find_by_id(params[:id])
    @answers = @question.answers
    @answer = Answer.new
    @comment = Comment.new
    @comments = Comment.relative_comments(@question.id,@question.class)
  end

  def destroy
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to students_path,flash: { error: "No such Question found for Delete!" }
    else
      @question.destroy
      redirect_to students_path,flash: { success: "Deleted Successfuly!" }
    end
  end

  def upvote
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: "No such Question found for Vote!" }
    else
      question_liked_by(@question,liked_by)
      redirect_to questions_path
    end
  end

  def downvote
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: "No such Question found for Vote!" }
    else
      question_disliked_by(@question,liked_by)
      redirect_to questions_path
    end
  end

  private
  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end

  def question_liked_by(question,user)
    question.liked_by(user)
  end

  def question_disliked_by(question,user)
    question.disliked_by(user)
  end
  
end
