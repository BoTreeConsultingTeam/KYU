module QuestionsHelper
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
