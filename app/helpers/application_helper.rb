module ApplicationHelper
  SALUTATIONS = %w[Mr Ms Mrs]
  PAGE_FILTERS = %w[student teacher basicinfo questions answers votes badges tags alltags allbadges]
  QUESTIONS_TAB = %w[all newest]

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
    link_to title, questions_path(active_tab: "#{active_tab}", active_link: t('administrator.active_link.home'), active_tab_menu: t('common.active_tab.all')),{'data-no-turbolink' => true, class: "questions_filter_link filter_link", remote: true}
  end

  def set_header_link_for_admin(users_type)
    link_to users_type, members_path(active_tab: users_type), {class: 'user_filter_link user_link', remote: true}
  end

  def student_badge_color(badge_name)
    if badge_name.blank?
      css_class = "user-badge" 
    elsif badge_name == "train"
      css_class = "user-badge-train"
    elsif badge_name == "Reviewer"
      css_class = "user-badge-reviewer"
    elsif badge_name == "Supporter"
      css_class = "user-badge-supporter"
    elsif badge_name == "Doctor"
      css_class = "user-badge-doctor"
    elsif badge_name == "Vice Professor"
      css_class = "user-badge-vice-professor"
    elsif badge_name == "Professor"
      css_class = "user-badge-professor"
    end
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
    @tags = Question.tag_counts_on(:tags).limit(Settings.tags.most_used_tags_limit).order('count desc')
  end

  def edit_user_registration_path
    edit_user_registration_path = current_student.present? ? edit_student_registration_path(current_student.id) : edit_teacher_registration_path(current_teacher.id)
  end

  def most_viewed_questions
    Question.joins(:impressions).group("questions.id").order("count(questions.id) DESC").limit(Settings.questions.most_viewed_questions_limit)
  end

  def user_signed_in
    student_signed_in? || teacher_signed_in? || administrator_signed_in?
  end

  def teacher_student_signed_in
    student_signed_in? || teacher_signed_in?
  end

  def profile_active_tab(active_tab=nil)
    css_class = ''
    if params[:active_tab].nil?
      params[:active_tab] = t('common.active_tab.all')
    end
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

  def menu_active_tab(active_tab_menu)
    css_class = ''
    
    active_tab_menu_param = params[:active_tab_menu]
    if active_tab_menu.present? && active_tab_menu_param.present? && active_tab_menu_param == active_tab_menu
      css_class = 'current-menu-item'
    elsif active_tab_menu_param.match('registrations') && active_tab_menu == "members"
      css_class = 'current-menu-item'
    elsif active_tab_menu_param.match('points') && active_tab_menu == "badges"
      css_class = 'current-menu-item'
    end
      css_class
  end

  def profile_active_link(active_link)
    css_class = ''
   
    
    active_link_param = params[:active_link]
    if active_link.present? && active_link_param.present? && active_link_param == active_link
      css_class = 'active_link'
    elsif active_link.blank? && active_link_param.present? && !PAGE_FILTERS.include?(active_link_param)
      css_class = 'active_link'
    elsif active_link.blank? && active_link_param.blank?
      css_class = 'active_link'
    end
      css_class
  end

  def list_of_users(user_type_tab,user, all_students)
    if !(user.blank?)
      case user_type_tab
      when "Teachers"
        render partial: 'members/teacher_member',locals: {teachers: user}
      when 'Students','Managers','Students for Review','Blocked Students'
        render partial: 'members/student_member',locals: {students: user, all_students: all_students}
      end
    else
      render partial: 'members/blank_messages',locals: {type: user_type_tab}
    end
  end

  def set_user_image image_path
    if image_path.present? && File.exists?(image_path)
      image_path
    else
      image_path = 'missing.jpeg'
    end
  end

  def void_link
    'javascript:void(0);'
  end
end
