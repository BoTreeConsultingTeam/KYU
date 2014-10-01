class Teachers::SessionsController <  Devise::SessionsController
  before_filter :current_user_present?, only:[:new]
  def new
    super
  end

  def after_sign_in_path_for(resource)
    teachers_path(active_tab: 'all')
  end
end

