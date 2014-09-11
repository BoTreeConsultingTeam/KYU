class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  def liked_by
    current_user
  end
  
  def user_signed_in?
    if current_user.nil?
      redirect_to root_path, flash: { error: "Sign in First" }
    end
  end
  
  def user_profile_update user
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end
    if user.update_attributes(account_update_params)
       set_flash_message :notice, :updated
       sign_in user, :bypass => true
       redirect_to after_update_path_for(user)
    else
       render "edit"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:salutation, :first_name,:middle_name, :last_name, :username,:birthdate]
    devise_parameter_sanitizer.for(:account_update) << [:salutation, :first_name, :middle_name, :last_name, :username, :birthdate, :qualification]
  end

  private
  def current_user
    current_user = current_student.present? ? current_student : current_teacher
  end
  helper_method :current_user
end
