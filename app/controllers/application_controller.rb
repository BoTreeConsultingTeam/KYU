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
  
  private
  def current_user
    current_user = current_student.present? ? current_student : current_teacher
  end
  helper_method :current_user
end
