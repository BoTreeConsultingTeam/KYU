class Students::RegistrationsController <  Devise::RegistrationsController
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
    params.require(:student).permit(:email, :password,:first_name, :middle_name, :last_name, :username,:birthdate)
  end

  def after_sign_in_path_for(resource)
    students_path
  end
end
