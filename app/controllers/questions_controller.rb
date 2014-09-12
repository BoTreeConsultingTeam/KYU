class QuestionsController < ApplicationController
  before_action :user_signed_in?
    
  def index
    if received_tag
      @questions = Question.tagged_with(received_tag).page params[:page]
    elsif received_time
      case received_time
      when 'week'
        @questions = Question.recent_data_week.page params[:page]
      when 'month'
        @questions = Question.recent_data_month.page params[:page]
      end
    else
      @questions = Question.all.page params[:page]
    end
  end

  def new
    @standards = Standard.all
    @question = Question.new
    @question.user_id = session[:id]
  end

  def create
    @question = Question.new(question_params.merge({askable: current_user}))
    if @question.save
      current_student.change_points(2)
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def show
    @question = Question.find_by_id(params[:id])
    if !(@question.nil?)
      @answers = @question.answers
      @answer = Answer.new
      impressionist(@question, nil, { unique: [:session_hash] })
      @comment = Comment.new
      @comments_q = Comment.relative_comments(@question.id,@question.class).page(params[:page]).per(params[:per])
      @comments_a = Comment.all_comments_of_answers(@answer.class)
    else
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.show') }
    end
  end

  def destroy
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to students_path,flash: { error: t('flash_massege.error.question.destroy') }
    else
      @question.destroy
      redirect_to students_path,flash: { success: t('flash_massege.success.question.destroy') }
    end
  end

  def vote
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.vote') }
    else
      if "up" == params[:type]
        question_liked_by(@question,liked_by)
        give_points(@question,5)
      else
        question_disliked_by(@question,liked_by)
        give_points(@question,-5)
      end
      respond_to do |format|
        format.js        
      end      
    end
  end
  
  def edit
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.edit') }
    end
  end
  
  def update
    @question = Question.find_by_id(params[:id])
    if !(@question.nil?) 
      @question.update(question_params)
      flash[:success] = t('flash_massege.success.question.update')
      redirect_to question_path(params[:id])
    else
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.update') }
    end 
  end

  def disable
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.disable') }
    else
      @question.enable = false
      @question.save
      redirect_to questions_path
    end
  end

  def abuse_report
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: t('flash_massege.error.question.report_abuse') }
    else
      Question.send_question_answer_abuse_report(current_user,@question)
      redirect_to questions_path,flash: { success: t('flash_massege.success.question.report_abuse') }
    end
  end

  def alltags
    @tags = ActsAsTaggableOn::Tag.all.page(params[:page]).per(5)
  end

  private
  def question_params
    params.require(:question).permit(:standard_id, :title, :content, :user_id, :tag_list)
  end

  def question_liked_by(question,user)
    question.liked_by(user)
  end

  def question_disliked_by(question,user)
    question.disliked_by(user)
  end

  def received_tag
    params[:tag]
  end

  def received_time
    params[:time]
  end
end
