class BookmarksController < ApplicationController

  def create
    @question = Question.find(params[:question_id])
    @question.bookmark!(current_user)
    flash[:notice] = "You have bookmark this question"
    redirect_to @question
  end

  def destroy 
    @question = Question.find(params[:question_id])
    @user = current_user
    bookmark = @user.bookmarks.where(:question_id => @question.id )
    bookmark.delete_all
    flash[:notice] = "Successfully delete bookmark"
    redirect_to @question
  end

end
