module ApplicationHelper
  SALUTATIONS = %w[Mr Ms Mrs]
  PAGE_FILTERS = %w[student teacher basicinfo questions answers votes badges tags]
  REGISTRATION_STATUSES = %w[latest, week, month]
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

  def set_link(title, time)
    link_to title, questions_path(:time => "#{time}"), {class: "#{active_pill("#{time}")}"}
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

end
