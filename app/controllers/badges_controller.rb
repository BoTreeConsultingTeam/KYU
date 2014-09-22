class BadgesController < ApplicationController
  before_action :user_signed_in?
  
  def index
    @badges = Badge.all
  end
end