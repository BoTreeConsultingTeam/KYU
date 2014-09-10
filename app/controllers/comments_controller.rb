class CommentsController < ApplicationController

  before_action :user_signed_in?
  
  def create 
    @comment = Comment.create(comment_params.merge({commentable: current_user}).merge({relative: params[:relative]}))
    
    if @comment.save
      if "Question" == relative_type
        @question = Question.find_by_id(params[:comment][:relative_id])
        @comments = Comment.relative_comments(params[:comment][:relative_id],params[:comment][:relative_type]).page params[:page]
      else
        @answer = Answer.find_by_id(params[:comment][:relative_id])
        @comments = Comment.relative_comments(params[:comment][:relative_id],params[:comment][:relative_type])
      end 
      respond_to do |format|
        format.js
      end
    else
      redirect_to questions_path
    end
  end
   
  def update
    @comment=Comment.find_by_id(params[:id])
    @comment.update(comment_params)
    if !(@comment.nil?)
      @comment.update(comment_params)
      if "Question" == relative_type
        redirect_to question_path(params[:comment][:relative_id]),flash: { success: t('flash_massege.success.comment.update') }
      else
        @answer = Answer.find_by_id(params[:comment][:relative_id])
        redirect_to question_path(@answer.question),flash: { success: t('flash_massege.success.comment.update') }
      end
    else
      if "Question" == relative_type
        redirect_to question_path(relative_id),flash: { error: t('flash_massege.error.comment.update') }
      else
        @answer = Answer.find_by_id(params[:comment][:relative_id])
        redirect_to question_path(@answer.question),flash: { error: t('flash_massege.error.comment.update') }  
      end
    end
  end

  def show
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(params[:question_id]),flash: { error: t('flash_massege.error.answer.comment') }
    else
      @comment = Comment.new
      @comments = Comment.relative_comments(@answer.id,@answer.class)
    end
  end
  
  def edit
    if params[:question_id]
      @question = Question.find_by_id(params[:question_id])
      @answers = @question.answers
      @comment = Comment.find_by_id(params[:id])
      if @comment.nil?
        redirect_to question_path(params[:question_id]),flash: { error: t('flash_massege.error.comment.edit') }
      else
        @comments_q = Comment.relative_comments(@question.id,@question.class)
      end
    else
      @answer = Answer.find_by_id(params[:answer_id])
      @comment = Comment.find_by_id(params[:id])
      if @comment.nil?
        redirect_to questions_path,flash: { error: t('flash_massege.error.comment.edit') }
      else       
        @comments = Comment.relative_comments(@answer.id,@answer.class)
      end
    end     
  end    

  def destroy
    @comment = Comment.find_by_id(params[:id])
    if !(@comment.nil?)
      @comment.delete
      if params[:answer_id].present?
        @answer = Answer.find_by_id(params[:answer_id])
        @comments = Comment.relative_comments(params[:answer_id],"Answer")
      else
        @question = Question.find_by_id(params[:question_id])
        @comments = Comment.relative_comments(params[:question_id],"Question")
      end
      respond_to do |format|
        format.js
      end
    else
      if params[:answer_id].present?
        @answer = Answer.find_by_id(params[:answer_id])
        @comments = Comment.all
        redirect_to question_path(@answer.question.id),flash: { error: "No such Comment found for Delete!" }
      else
        redirect_to question_path(params[:question_id]),flash: { error: "No such Comment found for Delete!" }
      end
        respond_to do |format|
          format.js
        end
    end
  end

  private

  def comment_params
      params.require(:comment).permit!
  end

  def relative_id
    params[:comment][:relative_id]
  end

  def relative_type
    params[:comment][:relative_type]
  end
end