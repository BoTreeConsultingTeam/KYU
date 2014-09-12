module ApplicationHelper
  SALUTATIONS = %w[Mr Ms Mrs]
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
    else
    end
    {css_class: css_class, msg_icon_class: msg_icon_class}
  end

  def options_for_salution
    options_for_select(SALUTATIONS)
  end

  def set_link(title, time)
    link_to title, questions_path(:time => "#{time}")
  end

  def set_header_link_for_admin(title, users)
    link_to title, members_path(users: "#{users}")
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
end
