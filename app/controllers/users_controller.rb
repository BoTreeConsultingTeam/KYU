class UsersController < ApplicationController
  before_action :authenticate_user!

  def create_member
    params[:user][:password] = SecureRandom.hex
    params[:user][:reset_password_token] = SecureRandom.urlsafe_base64
    @user = User.new(activity_params)
    if @user.save
      @user.new_user_account_notification(params[:user][:password])
      redirect_to admin_index_path
    else
      render 'users/new'
    end
  end

  protected

  def activity_params
    params.require(:user).permit(
      :salutation, :first_name, :middle_name, :last_name, :email, :date_of_birth, :password, :reset_password_token
    )
  end
end