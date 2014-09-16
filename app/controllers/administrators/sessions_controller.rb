class Administrators::SessionsController <  Devise::SessionsController

  def after_sign_in_path_for(resource)
    administrators_path
  end

  def destroy
	 super
  end 

  
end
