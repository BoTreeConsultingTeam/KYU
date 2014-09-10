class Teachers::RegistrationsController <  Devise::RegistrationsController
  
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

  private

  def sign_up_params
    params.require(:teacher).permit(:salutation,:name, :email, :password, :first_name, :last_name, :username, :qualification)
  end

  def after_sign_in_path_for(resource)
    teachers_path 
  end
end
