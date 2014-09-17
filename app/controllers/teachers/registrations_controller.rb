class Teachers::RegistrationsController <  Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
  
  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag])
    else
      @questions = Question.all.page params[:page]
    end
  end
  
  def create
    super
  end

  def view_profile
    @total_downvotes_question = 0
    @total_upvotes_question = 0
    @total_upvotes_answer = 0
    @total_downvotes_answer = 0
    @teacher = Teacher.find(params[:id])
    @questions = @teacher.questions
    @answers = @teacher.answers
    @tag = @teacher.owned_tags
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
    @user = Teacher.find(current_user.id)
    user_profile_update @user
  end
  

  private

  def sign_up_params
    params.require(:teacher).permit(:salutation,:name, :email, :password, :first_name, :last_name, :username, :qualification, :avatar)
  end

  def after_sign_in_path_for(resource)
    teachers_path 
  end
end
