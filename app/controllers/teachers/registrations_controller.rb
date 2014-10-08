class Teachers::RegistrationsController <  Devise::RegistrationsController
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :user_signed_in?, only:[:index,:view_profile,:update]
  before_filter :current_user_present?, only:[:new]
  
  def index
    if params[:tag]
      @questions = Kaminari.paginate_array(Question.tagged_with(params[:tag])).page(params[:page]).per(Kaminari.config.default_per_page)
    else
      @questions = Kaminari.paginate_array(all_questions).page(params[:page]).per(Kaminari.config.default_per_page) 
    end
  end

  def new
    super 
  end

  def create
    super
  end

  def view_profile
    @teacher = Teacher.find(params[:id])
    @questions = @teacher.questions.page params[:page]
    @answers = @teacher.answers
    @tag = @teacher.owned_tags
    @tags = @tag.map { |obj| [obj.name, obj.taggings_count]  }  
    @questions_likes_count  =  @teacher.questions.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
    @questions_dislikes_count  =  @teacher.questions.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_dislikes_count  =  @teacher.answers.map{|question|question.get_dislikes.count}.inject{|sum,val|sum+val}
    @answers_likes_count  =  @teacher.answers.map{|question|question.get_likes.count}.inject{|sum,val|sum+val}
    if !@questions_likes_count.nil?
      @total_questions_votes = @questions_likes_count + @questions_dislikes_count
    end

    if !@answers_likes_count.nil?
      @total_answers_votes = @answers_dislikes_count + @answers_likes_count
    end
    respond_to do |format| 
      format.html
      format.js
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
    teachers_path(active_tab: t('common.active_tab.all'))
  end
end
