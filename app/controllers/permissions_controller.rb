class PermissionsController < ApplicationController
  
  def destroy 
    bookmark = current_user.bookmarks.where(:question_id => @question.id )
    bookmark.destroy_all
    flash[:notice] = t('common.messages.delete_bookmark')
    redirect_to @question
  end

  def set_badge
    @badge = Badge.find(params[:id])
  end

  def permission_params
    params.require(:permission).permit(:rule_id, :id)
  end
end
