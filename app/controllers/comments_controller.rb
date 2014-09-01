class CommentsController < ApplicationController
before_action :user_signed_in?
  
  def create 
    relative_of_comment = params[:relative]
    @comment = Comment.create(comment_params.merge({commentable: current_user}).merge({relative: relative_of_comment}))
    if "Question" == relative_type
      redirect_to question_path(relative_id)
    else
      redirect_to comment_path(relative_id)
    end
  end
   
  def update
    @comment=Comment.find_by_id(params[:id])
    if !(@comment.nil?)
      @comment.update(comment_params)
      if "Question" == relative_type
        redirect_to question_path(relative_id),flash: { success: "Updated Successfully" }
      else
        redirect_to comment_path(relative_id),flash: { success: "Updated Successfully" }
      end
    else
      if "Question" == relative_type
        redirect_to question_path(relative_id),flash: { error: "no such Comment found for Update" }
      else
        redirect_to comment_path(relative_id),flash: { error: "no such Comment found for Update" }
      end
    end
  end

  def show
    @answer = Answer.find_by_id(params[:id])
    if @answer.nil?
      redirect_to question_path(params[:question_id]),flash: { error: "no such Answer found for Comment" }
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
        redirect_to question_path(params[:question_id]),flash: { error: "No such Comment found for Edit!" }
      else
        @comments = Comment.relative_comments(@question.id,@question.class)
      end
    else
      @answer = Answer.find_by_id(params[:answer_id])
      @comment = Comment.find_by_id(params[:id])
      if @comment.nil?
        redirect_to comment_path(params[:answer_id]),flash: { error: "No such Comment found for Edit!" }
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
        redirect_to comment_path(params[:answer_id]),flash: { success: "Deleted Successfully!" }
      else
        redirect_to question_path(params[:question_id]),flash: { success: "Deleted Successfully!" }
      end
    else
      if params[:answer_id].present?
        redirect_to comment_path(params[:answer_id]),flash: { error: "No such Comment found for Delete!" }
      else
        redirect_to question_path(params[:question_id]),flash: { error: "No such Comment found for Delete!" }
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