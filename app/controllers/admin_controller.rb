class AdminController < ApplicationController
  before_action :authenticate_user!
  def index
    @user = User.new
    render 'users/new'
  end
end
