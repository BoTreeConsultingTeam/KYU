class Administrators::SessionsController <  Devise::SessionsController

  def after_sign_in_path_for(resource)
    members_path
  end

  def destroy
    super
  end 
end
