class Students::SessionsController <  Devise::SessionsController
  before_filter :student_authorize, only: [:create]
  before_filter :current_user_present?, only:[:new]

  def new
    super
  end

  def destroy
    super
  end 

  def after_sign_in_path_for(resource)
  		students_path(active_tab_menu: 'all')
  end

  private

	def student_authorize
    if current_student
    	if current_student.enable == false
  			sign_out	
  			flash[:error] = t('students.messages.blocked_profile')
  			redirect_to student_session_path
      end	
    end	
	end
  
end
