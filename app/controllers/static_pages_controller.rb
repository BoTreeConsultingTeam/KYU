class StaticPagesController < ApplicationController
	before_filter :current_user_present?, only:[:index]

  def index
  end
end
