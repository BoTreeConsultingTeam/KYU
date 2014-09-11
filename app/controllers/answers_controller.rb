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
      redirect_to question_path(params[:answer][:question_id])
    else
      flash[:error]= 'Must contain some text'
      redirect_to question_path(params[:answer][:question_id])
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(params[:question_id]),flash: { error: t('flash_massege.error.answer.edit') }
    end
  end

  def update
    @answer = Answer.find_by_id(params[:id])
    if !(@answer.nil?)
      @answer.update(answer_params)
      redirect_to question_path(params[:answer][:question_id]),flash: { success: t('flash_massege.success.answer.update') }
    else
      redirect_to question_path(params[:answer][:question_id]),flash: { error: t('flash_massege.error.answer.update') }
    end    
  end

  def destroy
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(params[:question_id]), flash: { error: t('flash_massege.error.answer.destroy') }
    else
      @answer.destroy
      redirect_to question_path(params[:question_id]), flash: { success: t('flash_massege.success.answer.destroy') }
    end
  end

  def vote
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to questions_path,flash: { error: t('flash_massege.error.answer.vote') }
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
    @answer=Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(@answer.question),flash: { error: t('flash_massege.error.answer.accept') }
    else
      @answer.flag = true
      @answer.save
      give_points(@answer,10)
      redirect_to question_path(@answer.question),flash: { success: t('flash_massege.success.answer.accept') }
    end
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
end
