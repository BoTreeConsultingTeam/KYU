class Students::RegistrationsController <  Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?

  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all
    end
    @most_used_tags = tag_cloud
    @students_count = Student.count
    @teachers_count = Teacher.count
    @questions_count = Question.count
  end

  def create
    @student = build_resource
    @student.save
    super
  end

  def update 
    @user = Student.find(current_user.id)
    user_profile_update @user
  end

  def tag_cloud
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end

  private
  def sign_up_params
    params.require(:student).permit(:email, :password, :username, :birthdate, :student_class)
  end

  def after_sign_in_path_for(resource)
    students_path
  end
end
