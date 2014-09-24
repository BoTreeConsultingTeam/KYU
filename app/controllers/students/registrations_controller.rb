class Students::RegistrationsController <  Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_action :user_signed_in?, only:[:index,:view_profile,:update]
  def new
    @standard = Standard.all
    super
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
    @standard = Standard.all
    @student = build_resource
    @student.save
    super
  end

  def view_profile
    @student = Student.find(params[:id])
    @tag = @student.owned_tags
    @questions = @student.questions
    @tags = @tag.map { |obj| [obj.name, obj.taggings_count]  }
    @questions_likes_count  =  @student.questions.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
    @questions_dislikes_count  =  @student.questions.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_dislikes_count  =  @student.answers.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_likes_count  =  @student.answers.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
    @total_questions_votes = @questions_likes_count + @questions_dislikes_count
    @total_answers_votes = @answers_dislikes_count + @answers_likes_count
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
    params.require(:student).permit(:email, :password, :username, :birthdate, :standard_id, :avatar)
  end

  def after_sign_in_path_for(resource)
    students_path(active_tab: 'all')
  end
end
