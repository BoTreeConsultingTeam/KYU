class Students::SessionsController <  Devise::SessionsController

  def destroy
    super
  end 

  def after_sign_in_path_for(resource)
    students_path
  end
end
