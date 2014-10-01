class Teachers::SessionsController <  Devise::SessionsController
  before_filter :current_user_present?, only:[:new]
  def new
    super
  end

  def after_sign_in_path_for(resource)
    teachers_path
  end
end

