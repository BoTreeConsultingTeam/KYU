class AnswersController < ApplicationController
  before_action :user_signed_in?
  
  def new
    @answer = Answer.new
    @question =  Question.find(params[:question_id])
    question_id = @answer.question
  end

  def create
    @answer = Answer.create(answer_params.merge({answerable: current_user}))
    @question = @answer.question
    if @answer.save
      redirect_to_question(params[:answer][:question_id])
    else
      flash[:error] = t('answers.messages.contains_error')
      redirect_to_question(params[:answer][:question_id])
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    answer_find_by_id
    if answer_find_by_id.nil?
      flash[:error] = t('flash_message.error.answer.edit')
      redirect_to_question(params[:question_id])
    end
  end

  def update
    answer_find_by_id
    if !(answer_find_by_id.nil?)
      @answer.update(answer_params)
      flash[:success] = t('flash_message.success.answer.update')
    else
      flash[:error] = t('flash_message.error.answer.update')      
    end   
    redirect_to_question(params[:answer][:question_id]) 
  end

  def destroy
    answer_find_by_id
    if answer_find_by_id.nil?
      flash[:error] = t('flash_message.error.answer.destroy')
    else
      @answer.destroy
      flash[:success] = t('flash_message.success.answer.destroy')      
    end
    redirect_to_question(params[:question_id])
  end

  def vote
    answer_find_by_id
    if answer_find_by_id.nil?
      redirect_to questions_path,flash: { error: t('flash_message.error.answer.vote') }
    else
      if "up" == params[:type]        
        answer_liked_by(@answer,liked_by)
        give_points(@answer,15)
      else
        answer_disliked_by(@answer,liked_by)
        give_points(@answer,-15)
      end
      respond_to do |format|
        format.js        
      end  
    end
  end

  def accept
    answer_find_by_id
    if answer_find_by_id.nil?
      flash[:error] = t('flash_message.error.answer.accept')
    else
      @answer.flag = true
      @answer.save
      give_points(@answer,10)
      flash[:success] = t('flash_message.success.answer.accept')      
    end
    redirect_to_question(@answer.question)
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
  def answer_find_by_id
    @answer = Answer.find_by_id(params[:id])
  end

  def redirect_to_question(id)
    redirect_to question_path(id)
  end
end
