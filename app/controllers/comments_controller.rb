class CommentsController < ApplicationController

  before_action :user_signed_in?
  before_filter :comment_find_by_id, only: [:edit, :update, :destroy]
  
  def create 
    @rule = set_rule 4
    if check_permission current_user,@rule 
      @comment = Comment.new(comment_params.merge({commentable: current_user}).merge({relative: params[:relative]}))
      if @comment.save
        @comments = Comment.relative_comments(comment_relative_id,comment_relative_type).page params[:page]
        if "Question" == relative_type
          @question = Question.find_by_id(comment_relative_id)
        else
          @answer = find_by_answer_id(comment_relative_id)  
        end 
      else
        flash.now[:error] = t('comments.messages.create')
      end
    else
      flash.now[:error] = t('answers.messages.unauthorized')
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    
    if !(@comment.nil?)
      @comment.update(comment_params)
      flash[:notice] = t('flash_message.success.comment.update')
    else
      flash[:error] = t('flash_message.error.comment.update')
    end
    if "Question" == relative_type        
      redirect_to question_path(relative_id)
    else
      @answer = find_by_answer_id(comment_relative_id)
      redirect_to question_path(@answer.question) 
    end
  end

  def show
    AnswersController.answer_find_by_id
    if @answer.nil?
      redirect_to question_path(params[:question_id]),flash: { error: t('flash_message.error.answer.comment') }
    else
      @comment = Comment.new
      @comments = Comment.relative_comments(comment_find_by_id.id,comment_find_by_id.class)
    end
  end
  
  def edit
    if params[:question_id]
      @question = find_question
      @answers = @question.answers
      if @comment.nil?
        flash[:error] = t('flash_message.error.comment.edit')
        redirect_to question_path(params[:question_id])
      else
        require_permission @comment.commentable
        @question_comments = Comment.relative_comments(@question.id,@question.class)
      end
    else
      @answer = find_by_answer_id(params[:answer_id])
      comment_find_by_id
      if @comment.nil?
        flash[:error] = t('flash_message.error.comment.edit')
        redirect_to question_path(@answer.question)
      else       
        find_by_answer_id(params[:id])
        @answer_comments = Comment.relative_comments(@answer.id,@answer.class)
      end
    end     
  end    

  def destroy
    if !(@comment.nil?)
      require_permission @comment.commentable
      @comment.delete
    else
      flash[:error] = t('comments.messages.comment_not_found')
    end
    if params[:answer_id].present?
      @answer = find_by_answer_id(params[:answer_id])
      @comments = Comment.relative_comments(params[:answer_id],"Answer")
    else
      @question = find_question
      @comments = Comment.relative_comments(params[:question_id],"Question").page params[:page]
    end
    respond_to do |format|
      format.js
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

  def find_by_answer_id(id)
    Answer.find_by_id(id)
  end

  def comment_relative_id
    params[:comment][:relative_id]
  end

  def comment_relative_type
    params[:comment][:relative_type]
  end

  def comment_find_by_id
    @comment = Comment.find_by_id(params[:id])
  end

  def find_question
    Question.find_by_id(params[:question_id])
  end
end