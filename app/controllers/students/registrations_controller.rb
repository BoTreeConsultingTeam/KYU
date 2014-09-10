class Students::RegistrationsController <  Devise::RegistrationsController
  
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all.page params[:page]
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
    @students = resource
    super
  end
  def tag_cloud
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end
  private
  
  def sign_up_params
    params.require(:student).permit(:email, :password,:first_name, :middle_name, :last_name, :username,:birthdate,:student_class)
  end

  def after_sign_in_path_for(resource)
    students_path
  end
end
