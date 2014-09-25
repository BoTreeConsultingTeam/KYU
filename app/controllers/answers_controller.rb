class AnswersController < ApplicationController
  before_action :user_signed_in?
  before_filter :answer_find_by_id, only: [:edit, :update, :destroy, :vote, :accept]
  def new
    @answer = Answer.new
    @question =  Question.find(params[:question_id])
    question_id = @answer.question
  end

  def create
    @rule = set_rule 6
    if check_permission current_user,@rule
      @answer = Answer.new(answer_params.merge({answerable: current_user}))
      @question = @answer.question
      if @answer.save
        give_points(@answer, Point.action_score(2))
        redirect_to_question(params[:answer][:question_id])
      else
        flash[:error] = t('answers.messages.contains_error')
        redirect_to_question(params[:answer][:question_id])
      end
    else
      flash[:error] = t('answers.messages.unauthorized')
      redirect_to questions_path
    end
  end

  def edit
    @question = Question.find(params[:question_id])
    @answers = @question.answers
    if @answer.nil?
      flash[:error] = t('flash_message.error.answer.edit')
      redirect_to_question(params[:question_id])
    end
  end

  def update
    answer_find_by_id
    if !(answer_find_by_id.nil?)
      @answer.update(answer_params)
      flash[:notice] = t('flash_message.success.answer.update')
    else
      flash[:error] = t('flash_message.error.answer.update')      
    end   
    redirect_to_question(params[:answer][:question_id]) 
  end

  def destroy
    if @answer.nil?
      flash[:error] = t('flash_message.error.answer.destroy')
    else
      @answer.destroy
      flash[:notice] = t('flash_message.success.answer.destroy')      
    end
    redirect_to_question(params[:question_id])
  end

  def vote
    @rule = set_rule 2
    if check_permission current_user,@rule
      
      if @answer.nil?
        redirect_to questions_path(active_tab: 'all'),flash: { error: t('flash_message.error.answer.vote') }
      else
        if "up" == params[:type]
          if !@answer.get_likes.map{|vote| vote.voter}.include?current_user
            answer_liked_by(@answer, liked_by)
            give_points(@answer, Point.action_score(4))
          end
        else
          if !@answer.get_dislikes.map{|vote| vote.voter}.include?current_user
            answer_disliked_by(@answer,liked_by)
            give_points(@answer, Point.action_score(6))
          end
        end
        respond_to do |format|
          format.js        
        end  
      end
    else
      flash[:error] = t('answers.messages.unauthorized')
      redirect_to questions_path
    end
  end

  def accept
    answer_find_by_id
    if answer_find_by_id.nil?
      flash[:error] = t('flash_message.error.answer.accept')
    else
      @answer.flag = true
      @answer.save     
      give_points(@answer, Point.action_score(7))
      flash[:notice] = t('flash_message.success.answer.accept')      
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
