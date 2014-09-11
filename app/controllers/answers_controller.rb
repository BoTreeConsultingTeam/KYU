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
      redirect_to question_path(params[:question_id]),flash: { error: "No such Answer found for edit!" }
    end
  end

  def update
    @answer = Answer.find_by_id(params[:id])
    if !(@answer.nil?)
      @answer.update(answer_params)
      redirect_to question_path(params[:answer][:question_id]),flash: { success: "Updated Successfully!" }
    else
      redirect_to question_path(params[:answer][:question_id]),flash: { error: "No such Answer found for Update!" }
    end    
  end

  def destroy
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(params[:question_id]), flash: { error: "No such Answer found for delete!" }
    else
      @answer.destroy
      redirect_to question_path(params[:question_id]), flash: { success: "Deleted successfully!" }
    end
  end

  def upvote
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to questions_path,flash: { error: "No such Answer found for Vote!" }
    else
      answer_liked_by(@answer,liked_by)
      give_points(@answer,15)
      redirect_to question_path(@answer.question)
    end
  end

  def downvote
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to questions_path,flash: { error: "No such Answer found for Vote!" }
    else
      answer_disliked_by(@answer,liked_by)
      give_points(@answer,-15)
      redirect_to question_path(@answer.question)
    end
  end

  def accept
    @answer=Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(@answer.question),flash: { error: "No such Answer found for Accept!" }
    else
      @answer.flag = true
      @answer.save
      give_points(@answer,10)
      redirect_to question_path(@answer.question),flash: { success: "Answer Accepted!" }
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
