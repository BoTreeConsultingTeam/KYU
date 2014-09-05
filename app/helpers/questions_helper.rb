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
  def check_bookmark question
    current_user.bookmarks.where(:question_id => question.id)  
  end  

  def bookmark_question_ids student
    question_list = []
    question_ids =  student.bookmarks.pluck(:question_id)
    question_ids.each do |id|
      question = Question.find_by_id(id)
      question_list << question
    end
    question_list
  end
end
