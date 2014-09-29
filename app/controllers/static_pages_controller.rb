class StaticPagesController < ApplicationController
	
  def index
    if !current_user.nil?
      redirect_to questions_path(active_tab: 'all')
    end
  end
end
