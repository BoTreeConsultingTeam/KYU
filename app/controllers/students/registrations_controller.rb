class Students::RegistrationsController <  Devise::RegistrationsController
  before_action :authenticate_student!,only:[:index,:edit]
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

  def authenticate_student!
    if current_student.nil?
      redirect_to root_path
    end
  end
end
