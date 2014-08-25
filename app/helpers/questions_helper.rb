module QuestionsHelper
  def get_user_name(id)
    Student.find(Question.find(id)).first_name
  end

  def set_link(title,time)
  	link_to title, questions_path(:time => 'week')
  end
end
