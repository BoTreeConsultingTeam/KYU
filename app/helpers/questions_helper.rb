module QuestionsHelper
  include ActsAsTaggableOn::TagsHelper
  
  def link_for(link_text,time)
    link_to "#{link_text}", questions_path(:time => "#{time}")
  end
  
  def ask_question
    button_to  'Ask Question', new_question_path,method: :get, class:" btn btn-primary pull-right"
  end

  def vote_question_link(question,vote)
    if 'up'== vote
      css_class = "action vote vote-up img-circle fa fa-chevron-up"
    else
      css_class = "action vote vote-up img-circle fa fa-chevron-down"
    end
		link_to '', vote_question_path(question,type: vote), method: "post",class: css_class,remote: true, :"data-replace" => '#some_id'
	end
  
  def tags_of_this_question(question)
    raw question.tag_list.map { |t| link_to t, tag_path(t) }.join(', ')
  end
  
  def get_tag_counts
    Question.tag_counts
  end
end
