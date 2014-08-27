class CommentsController < ApplicationController
before_action :authenticate_user!

  def index
  end 

  def create 
    relative_of_comment = params[:relative]
    @comment = Comment.create(comment_params.merge({commentable: current_user}).merge({relative: relative_of_comment}))
    redirect_to :back
  end
   
  def update
    @comment=Comment.find_by_id(params[:id])
    @comment.update(comment_params)
    if params[:comment][:commentable_id].present?
      redirect_to question_path(params[:comment][:commentable_id])
    else
      redirect_to comment_path(params[:comment][:relative_id])
    end
  end

  def new
   @question = Question.new
   @comment = @post.comments.build
  end

  def show
    @answer = Answer.find(params[:id])
    @comment = Comment.new
  end
  
  def edit
   if params[:question_id]
     @question = Question.find(params[:question_id])
     @answers = @question.answers
     @comment = Comment.find(params[:id])
   else
     @answer = Answer.find(params[:answer_id])
     @comment = Comment.find(params[:id])
   end     
  end    

  def destroy
    @comment = Comment.find(params[:id]).delete
    if params[:answer_id].present?
      redirect_to comment_path(params[:answer_id])
    else
      redirect_to question_path(params[:question_id])
    end
  end

  private

  def comment_params
      params.require(:comment).permit!
  end
end