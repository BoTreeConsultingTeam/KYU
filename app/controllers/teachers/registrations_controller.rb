class Teachers::RegistrationsController <  Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end
  end
  
  def create
    super
  end
  
  def update 
    @user = Teacher.find(current_user.id)
    user_profile_update @user
  end
  

  private

  def sign_up_params
    params.require(:teacher).permit(:salutation,:name, :email, :password, :first_name, :last_name, :username, :qualification)
  end

  def after_sign_in_path_for(resource)
    teachers_path 
  end
end
