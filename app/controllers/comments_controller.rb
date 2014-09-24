class CommentsController < ApplicationController

  before_action :user_signed_in?
  
  def create 
    @comment = Comment.new(comment_params.merge({commentable: current_user}).merge({relative: params[:relative]}))
    @comments = Kaminari.paginate_array(Comment.relative_comments(comment_relative_id,comment_relative_type)).page(params[:page]).per(Settings.pagination.per_page_5) 
    if @comment.save
      if "Question" == relative_type
        @question = Question.find_by_id(comment_relative_id)
      else
        @answer = find_by_answer_id(comment_relative_id)  
      end 
      respond_to do |format|
        format.js
      end
    else
      redirect_to questions_path(active_tab: 'all')
    end
  end
   
  def update
    comment_find_by_id
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
      @question = Question.find_by_id(params[:question_id])
      @answers = @question.answers
      comment_find_by_id
      if @comment.nil?
        redirect_to question_path(params[:question_id]),flash: { error: t('flash_message.error.comment.edit') }
      else
        @question_comments = Comment.relative_comments(@question.id,@question.class)
      end
    else
      @answer = find_by_answer_id(params[:answer_id])
      comment_find_by_id
      if @comment.nil?
        redirect_to questions_path(active_tab: 'all'),flash: { error: t('flash_message.error.comment.edit') }
      else       
        find_by_answer_id(params[:id])
        @answer_comments = Comment.relative_comments(@answer.id,@answer.class)
      end
    end     
  end    

  def destroy
    comment_find_by_id
    if !(comment_find_by_id.nil?)
      @comment.delete
      if params[:answer_id].present?
        @answer = find_by_answer_id(params[:answer_id])
        @comments = Comment.relative_comments(params[:answer_id],"Answer")
      else
        @question = Question.find_by_id(params[:question_id])
        @comments = Comment.relative_comments(params[:question_id],"Question").page params[:page]
      end
      respond_to do |format|
        format.js
      end
    else
      if params[:answer_id].present?
        @answer = find_by_answer_id(params[:id])
        @comments = Comment.all
        redirect_to question_path(@answer.question.id),flash: { error: "No such Comment found for Delete!" }
      else
        redirect_to question_path(params[:question_id]),flash: { error: t('comments.messages.comment_not_found') }
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

end