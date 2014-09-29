class Teachers::SessionsController <  Devise::SessionsController
  
  def new
    if current_user.nil?
      super 
    else
      redirect_to questions_path(active_tab: 'all')
    end
  end

  def after_sign_in_path_for(resource)
    teachers_path(active_tab: 'all')
  end
end

