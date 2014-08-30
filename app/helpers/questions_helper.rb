module QuestionsHelper

  include ActsAsTaggableOn::TagsHelper
  
  def link_for(link_text,time)
    link_to "#{link_text}", questions_path(:time => "#{time}")
  end

  def set_link(title,time)
  	link_to title, questions_path(:time => "#{time}")
  end

	def vote_up_question_link(question)
		link_to '', upvote_question_path(question), method: "post"
	end
  
	def vote_down_question_link(question)
		link_to 'Vote Down', downvote_question_path(question), method: "post"
	end

	def current_user
		current_user = current_student.present? ? current_student : current_teacher
	end

  def get_tag_counts
    Question.tag_counts
  end
end
