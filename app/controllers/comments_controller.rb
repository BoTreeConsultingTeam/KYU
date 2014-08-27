class CommentsController < ApplicationController

	before_action :authenticate_user!

	def index
	end	

    def create
		
		relative_of_comment = params[:relative]
		@comment = Comment.create(comment_params.merge({commentable: logged_in_user}).merge({relative: relative_of_comment}))
		
		redirect_to :back
	end
   
    def update
    	@comment=Comment.find_by_id(params[:id])
    	@comment.update(comment_params)
    	redirect_to question_path(params[:comment][:relative_id])
    end

    def new
    	@question = Question.new
  		@comment = @post.comments.build
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

    private

    def comment_params
        params.require(:comment).permit!
    end

    def current_user
    	current_user = current_student.present? ? current_student : current_teacher
    end
    def logged_in_user
    	logged_in_user = current_student ? current_student : current_teacher
    end

    def authenticate_user!
    	if logged_in_user.nil?
    		redirect_to root_path
    	end
    end
end