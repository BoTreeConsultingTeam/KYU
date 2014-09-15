class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception
  
  def liked_by
    current_user
  end
  
  def user_signed_in?
    if current_user.nil?
      redirect_to root_path, flash: { error: t('common.messages.sign_in') }
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

  def give_points(object, points)
      if object.is_a? Question
        user = object.askable  
      else
        user = object.answerable
      end 
      if user.is_a? Student
        user.change_points(points)    
      end
  end
end
