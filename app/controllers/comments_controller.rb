class CommentsController < ApplicationController
	def create
      comment = Comment.new comment_params
      commentable = params[:comment][:commentable_type].constantize.find(params[:comment][:commentable_id])
      comment.commentable = commentable
      comment.user_id = current_user.id
      comment.role = current_user.class.to_s
      comment.save

      redirect_to :back

    end

    
    private

    def comment_params
        params.require(:comment).permit!
    end

    def current_user
    	current_user = current_student.present? ? current_student : current_teacher
    end
end