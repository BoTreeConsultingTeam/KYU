class Students::RegistrationsController <  Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_action :user_signed_in?, only:[:index,:view_profile,:update]
  def new
    @standard = Standard.all
    super
  end
  
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
    @standard = Standard.all
    @student = build_resource
    @student.save
    super
  end

  def view_profile
    @total_downvotes_question = 0
    @total_upvotes_question = 0
    @total_upvotes_answer = 0
    @total_downvotes_answer = 0
    @student = Student.find(params[:id])
    @questions = @student.questions
    @answers = @student.answers
    @badges = @student.badges
    @tag = @student.owned_tags
    @tags = @tag.map { |obj| [obj.name, obj.taggings_count]  }
    @questions.each do |question|
      @total_upvotes_question = @total_upvotes_question + question.get_upvotes.size
    end
    @questions.each do |question|
      @total_downvotes_question = @total_downvotes_question + question.get_downvotes.size
    end
    @answers.each do |answer|
      @total_upvotes_answer = @total_upvotes_answer + answer.get_upvotes.size
    end

    @answers.each do |answer|
      @total_downvotes_answer = @total_downvotes_answer + answer.get_downvotes.size
    end
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
