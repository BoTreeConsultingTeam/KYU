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

  def view_profile
    @total_downvotes_question = 0
    @total_upvotes_question = 0
    @total_upvotes_answer = 0
    @total_downvotes_answer = 0
    @student = Student.find(params[:id])
    @questions = @student.questions
    @answers = @student.answers
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
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # Allow user to update without using password.
    if account_update_params[:password].blank?
      logger.debug "+++++++++++++++++++++++++ debug1"
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    # Set current_user
    @user = Student.find(current_user.id)
    if @user.update_attributes(account_update_params)
      set_flash_message :notice, :updated
      sign_in @user, :bypass => true
      redirect_to after_update_path_for(@user)
    else
       render "edit"
    end
    
  end

  def tag_cloud
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :middle_name, :last_name, :username, :birthdate, :avatar]
    devise_parameter_sanitizer.for(:account_update) << [:first_name,:middle_name, :last_name, :username,:birthdate, :avatar]
    # devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:first_name,:middle_name, :last_name, :username,:birthdate) }
    # devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name,:middle_name, :last_name, :username,:birthdate) }
  end

  private
  
  def after_sign_in_path_for(resource)
    students_path
  end
end
