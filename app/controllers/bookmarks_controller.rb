class BookmarksController < ApplicationController
  before_action :set_question
  def create
    @question.bookmark(current_user)
    flash[:notice] = "You have bookmark this question"
    redirect_to @question
  end

  def destroy 
    bookmark = current_user.bookmarks.where(:question_id => @question.id )
    bookmark.destroy_all
    flash[:notice] = "Successfully delete bookmark"
    redirect_to @question
  end

  def set_question
    @question = Question.find(params[:question_id])
  end
end
