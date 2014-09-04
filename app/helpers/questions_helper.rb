module QuestionsHelper
  include ActsAsTaggableOn::TagsHelper
  
  def link_for(link_text,time)
    link_to "#{link_text}", questions_path(:time => "#{time}")
  end
  
  def ask_question
    button_to  'Ask Question', new_question_path,method: :get, class:" btn btn-primary pull-right"
  end

  def vote_up_question_link(question)
		link_to '', upvote_question_path(question), method: "post",class: 'action vote vote-up img-circle fa fa-chevron-up'
	end
  
	def vote_down_question_link(question)
		link_to '', downvote_question_path(question), method: "post",class: 'action vote vote-down img-circle fa fa-chevron-down'
	end

  def tags_of_this_question(question)
    raw question.tag_list.map { |t| link_to t, tag_path(t) }.join(', ')
  end
  
  def get_tag_counts
    Question.tag_counts
  end
end
