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
    @question = question_find_by_id
    if !(@question.nil?)
      @answers = @question.answers
      @answer = Answer.new
      impressionist(@question, nil, { unique: [:session_hash] })
      @comment = Comment.new
      @question_comments = Comment.relative_comments(@question.id,@question.class).page(params[:page]).per(params[:per])
      @answer_comments = Comment.all_comments_of_answers(@answer.class)
    else
      redirect_to questions_path,flash: { error: t('flash_message.error.question.show') }
    end
  end

  def destroy
    @question = question_find_by_id
    if question_find_by_id.nil?
      flash[:error] = t('flash_message.error.question.destroy')
    else
      @question.destroy
      flash[:success] = t('flash_message.success.question.destroy')
    end
    redirect_to students_path
  end

  def vote
    @question = question_find_by_id
    if question_find_by_id.nil?
      redirect_to questions_path,flash: { error: t('flash_message.error.question.vote') }
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
    @question = question_find_by_id
    if question_find_by_id.nil?
      redirect_to questions_path,flash: { error: t('flash_message.error.question.edit') }
    end
  end
  
  def update
    @question = question_find_by_id
    if !(@question.nil?) 
      @question.update(question_params)
      flash[:success] = t('flash_message.success.question.update')
      redirect_to question_path(params[:id])
    else
      redirect_to questions_path,flash: { error: t('flash_message.error.question.update') }
    end 
  end

  def disable
    @question = question_find_by_id
    if @question.nil?
      flash[:error] = t('flash_message.error.question.disable')
    else
      @question.enabled = false
      @question.save
    end
    redirect_to questions_path
  end

  def abuse_report
    question_find_by_id
    if question_find_by_id.nil?
      flash[:error] =  t('flash_message.error.question.report_abuse') 
    else
      Question.send_question_answer_abuse_report(current_user,@question)
      flash[:success] = t('flash_message.success.question.report_abuse')
    end
    redirect_to questions_path
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

  def question_find_by_id
    Question.find_by_id(params[:id])
  end
end
