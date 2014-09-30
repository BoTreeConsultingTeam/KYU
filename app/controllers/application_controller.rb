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

  def current_user_present?
    if !current_user.nil?
      redirect_to questions_path(active_tab: t('common.active_tab.all'))
    end
  end

  def all_questions
    Question.enabled.order("created_at desc")
  end
  
  def user_badge user
    user.badges.last
  end

  def set_rule id
    Rule.find_by_id(id)
  end
  
  def badge_rules badge
    badge.rules.map{|rule|rule.id}
  end

  def check_permission user,rule
    if current_teacher
      true
    else
      badge = user_badge user
      if !badge.nil?
        rule_arr = badge_rules badge
        if rule_arr.include? rule.id
          return true
        else
          return false
        end
      end
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
      if current_student
        redirect_to student_views_profile_path(user, active_tab: 'basicinfo')
      else
        redirect_to teacher_views_profile_path(user)
      end
    else
      render "edit"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:salutation, :first_name,:middle_name, :last_name, :username,:birthdate, :standard_id, :avatar]
    devise_parameter_sanitizer.for(:account_update) << [:salutation, :first_name, :middle_name, :last_name, :username, :birthdate, :qualification, :standard_id, :avatar]
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
