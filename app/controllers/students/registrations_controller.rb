class Students::RegistrationsController <  Devise::RegistrationsController
   before_filter :configure_permitted_parameters, if: :devise_controller?
   before_action :user_signed_in?, only:[:index,:view_profile,:update]
   before_filter :standard_list, only: [:new,:edit,:view_profile,:update,:create]
  def new
    super
  end
  
  def index
    if params[:tag]
      @questions = Kaminari.paginate_array(Question.tagged_with(params[:tag]).enabled).page(params[:page]).per(Kaminari.config.default_per_page)
    else
      @questions = Kaminari.paginate_array(all_questions).page(params[:page]).per(Kaminari.config.default_per_page)
    end
    @most_used_tags = tag_cloud
    @students_count = Student.count
    @teachers_count = Teacher.count
    @questions_count = Question.count
  end

  def create
    @standards = Standard.all
    @student = build_resource
    super
  end
  
  def edit
    super
  end

  def view_profile
    params[:active_link] = 'profile'
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
    @total_likes = @questions_likes_count.to_i + @answers_likes_count.to_i
    @total_dislikes = @questions_dislikes_count.to_i + @answers_dislikes_count.to_i


    @question_ids_strong_area = @student.questions.map {|obj| obj.id}
    @strong_area_all = map_array_for_chart(@question_ids_strong_area,0)
    @chart_strong_all = GoogleChartService.render_reports_charts( @strong_area_all, :bar, "Student's tag ratio", true, 'Tag', 'Count', false )
    @strong_area_3 = map_array_for_chart(@question_ids_strong_area,1)
    @chart_strong_3 = GoogleChartService.render_reports_charts( @strong_area_3, :bar, "Student's tag ratio", true, 'Tag', 'Count', false )
    @accepted_answers = @student.answers.accepted_answers
    @question_ids_weak_area = @accepted_answers.map {|obj| obj.question_id}
    @weak_area_all = map_array_for_chart(@question_ids_weak_area,0)
    @chart_weak_all = GoogleChartService.render_reports_charts( @weak_area_all, :bar, "Student's tag ratio", true, 'Tag', 'Count', false )
    @weak_area_3 = map_array_for_chart(@question_ids_weak_area,1)
    @chart_weak_3 = GoogleChartService.render_reports_charts( @weak_area_3, :bar, "Student's tag ratio", true, 'Tag', 'Count', false )
  end

  def update
    @student = Student.find(current_user.id)
    user_profile_update @student
  end

  def tag_cloud
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end

  def standard_list
    @standards = Standard.all
  end


  private


  def sign_up_params
    params.require(:student).permit(:email, :password, :username, :birthdate, :standard_id, :avatar)
  end

  def after_sign_in_path_for(resource)
    students_path(active_tab: 'all')
  end

  def map_array_for_chart(question_ids, flag)
    tag_ids_of_question = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(question_ids).map { |obj| obj.tag_id }
    students_tags = tag_ids_of_question.group_by{|tag_id| tag_id}.map{|tag_id,tag_count| [ ActsAsTaggableOn::Tag.find_all_by_id(tag_id).map {|obj| obj.name}, tag_count.count].flatten }
    @sorted_reverse_array = students_tags.sort {|a,b| a[1] <=> b[1]}.reverse
    if flag ==0
      @sorted_reverse_array
    else
      @first_3_elements = @sorted_reverse_array.slice(0,3)
    end
  end
  
end
