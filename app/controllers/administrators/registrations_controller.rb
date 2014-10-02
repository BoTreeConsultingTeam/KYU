class Administrators::RegistrationsController <  Devise::RegistrationsController
  
  def after_sign_in_path_for(resource)
    administrators_path
  end
end
