class Teachers::RegistrationsController <  Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
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
    # @teacher.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    # if @teacher.save
    #   redirect_to root_path
    # end
    # super
    account_update_params = devise_parameter_sanitizer.sanitize(:account_update)

    # Allow user to update without using password.
    if account_update_params[:password].blank?
      account_update_params.delete("password")
      account_update_params.delete("password_confirmation")
    end

    # Set current_user
    @user = Teacher.find(current_user.id)
    if @user.update_attributes(account_update_params)
       set_flash_message :notice, :updated
       sign_in @user, :bypass => true
       redirect_to after_update_path_for(@user)
    else
       render "edit"
    end
    
  end
  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:salutation, :first_name,:middle_name, :last_name, :username,:birthdate,:avatar]
    devise_parameter_sanitizer.for(:account_update) << [:salutation, :first_name,:middle_name,:qualification, :last_name, :username,:birthdate,:avatar]
  end

  private

  def sign_up_params
    params.require(:teacher).permit(:salutation,:name, :email, :password, :first_name, :last_name, :username, :qualification, :avatar)
  end

  def after_sign_in_path_for(resource)
    teachers_path 
  end
end
