module QuestionsHelper
  private
    def received_tag
      params[:tag]
    end

    def received_time
      params[:time]
    end

    def link_for(link_text,time)
      link_to "#{link_text}", questions_path(:time => "#{time}")
    end
    
  def get_user_name(id)
    Student.find(Question.find(id)).first_name
  end

  def set_link(title,time)
  	link_to title, questions_path(:time => 'week')
  end

	def vote_up_question_link(question)
		link_to 'Vote Up', upvote_question_path(question), method: "post"
	end
	def vote_down_question_link(question)
		link_to 'Vote Down', downvote_question_path(question), method: "post"
	end

	def current_user
		current_user = current_student.present? ? current_student : current_teacher
	end
end
