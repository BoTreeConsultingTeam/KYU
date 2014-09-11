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
