class Students::RegistrationsController <  Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_action :user_signed_in?, only:[:index,:view_profile,:update]
  def new
    @standards = Standard.all
    @divisions = Division.all
    super
  end

  def update_division
    # @form_object = params[:object]
    standard = Standard.find(params[:student][:standard_id])
    @divisions = standard.divisions
    respond_to do |format|
      format.js { render 'students/registrations/update_division' }
    end
  end
  
  def index
    if params[:tag]
      @questions = Kaminari.paginate_array(Question.tagged_with(params[:tag])).page(params[:page]).per(Kaminari.config.default_per_page)
    else
      @questions = Kaminari.paginate_array(Question.all).page(params[:page]).per(Kaminari.config.default_per_page)
    end
    @most_used_tags = tag_cloud
    @students_count = Student.count
    @teachers_count = Teacher.count
    @questions_count = Question.count
  end

  def create
    puts "+++++++++#{sign_up_params}===="
    puts "@@@@@@@@#{params[:division]}======================="
    @divisions = Division.all
    @student = build_resource
    puts "===========#{@student.inspect}++++++++++++"
    super
    puts "===========debug1+++++++++++++++++++++++++++++++++++++"
  end

  def view_profile
    @student = Student.find(params[:id])
    @badges = @student.badges
    @rules = Rule.all
    @answers = @student.answers
    @questions = @student.questions.page params[:page]
    @tags = @student.owned_tags.page params[:page]
    @questions_likes_count  =  @student.questions.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
    @questions_dislikes_count  =  @student.questions.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_dislikes_count  =  @student.answers.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_likes_count  =  @student.answers.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
   
  end

  def update
    @student = Student.find(current_user.id)
    user_profile_update @student
  end

  def tag_cloud
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end

  private
  def sign_up_params
    params.require(:student).permit(:email, :password, :username, :birthdate, :standard_id, :avatar, :division =>[:division_id])
  end

  def after_sign_in_path_for(resource)
    students_path(active_tab: 'all')
  end
end
