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
    if(current_administrator.present?)
      current_user = current_administrator
    elsif(current_teacher.present?)
      current_user = current_teacher
    else
      current_user = current_student   
    end      
  end
  helper_method :current_user
end
