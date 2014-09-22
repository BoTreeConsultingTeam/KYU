module ApplicationHelper
  SALUTATIONS = %w[Mr Ms Mrs]
  PAGE_FILTERS = %w[student teacher basicinfo questions answers votes badges tags]
  def render_css_class(name)
    css_class = ''
    msg_icon_class = ''
    case name
    when :error, :redirect_error
      css_class = 'alert-danger'
      msg_icon_class = 'icon-remove'
    when :notice, :redirect_notice
      css_class = 'alert-success'
      msg_icon_class = 'icon-ok'
    when :alert
      css_class = 'alert-danger'
      msg_icon_class = 'icon-remove'
    end
    {css_class: css_class, msg_icon_class: msg_icon_class}
  end

  def options_for_salution
    options_for_select(SALUTATIONS)
  end

  def set_link(title, active_tab)
    link_to title, questions_path(:active_tab => "#{active_tab}"),{'data-no-turbolink' => true,class: profile_active_tab("#{active_tab}")}
  end

  def set_header_link_for_admin(users_type)
    link_to users_type, members_path(active_tab: users_type), {class: profile_active_tab("#{users_type}")}
  end

  def questions_count
    Question.count
  end

  def students_count
    Student.count
  end

  def teachers_count
    Teacher.count
  end

  def most_used_tags
    @tags = Question.tag_counts_on(:tags).limit(5).order('count desc')
  end
  
  def edit_user_registration_path
    edit_user_registration_path = current_student.present? ? edit_student_registration_path(current_student.id) : edit_teacher_registration_path(current_teacher.id)
  end

  def most_viewed_questions
    Question.joins(:impressions).group("questions.id").order("count(questions.id) DESC").limit(5)
  end

  def user_signed_in
    student_signed_in? || teacher_signed_in? || administrator_signed_in?
  end  

  def teacher_student_signed_in
    student_signed_in? || teacher_signed_in?
  end  

  def active_pill(time=nil)
    css_class = ''
    filter_status = params[:time]
    if time.present? && filter_status.present? && filter_status == time
      css_class = 'active'
    elsif time.blank? && filter_status.present? && !REGISTRATION_STATUSES.include?(filter_status)
      css_class = 'active'
    elsif time.blank? && filter_status.blank?
      css_class = 'active'
    end
    css_class
  end

  def profile_active_tab(active_tab=nil)
    css_class = ''
    active_tab_param = params[:active_tab]
    if active_tab.present? && active_tab_param.present? && active_tab_param == active_tab
      css_class = 'active'
    elsif active_tab.blank? && active_tab_param.present? && !PAGE_FILTERS.include?(active_tab_param)
      css_class = 'active'
    elsif active_tab.blank? && active_tab_param.blank?
      css_class = 'active'
    end
      css_class
  end

  def list_of_users(user_type_tab,user)  
    case user_type_tab
    when "Teachers"
      render partial: 'members/teacher_member',locals: {teachers: user}
    when 'Students','Managers','Students for Review','Blocked Students'
      if !(user.blank?)
        render partial: 'members/student_member',locals: {students: user}
      else
        render partial: 'members/blank_messages',locals: {type: user_type_tab}
      end
    end
  end
end
