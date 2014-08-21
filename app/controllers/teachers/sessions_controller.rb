class Teachers::SessionsController <  Devise::SessionsController
  def after_sign_in_path_for(resource)
    teachers_path
  end
end

