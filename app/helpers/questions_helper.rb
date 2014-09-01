module QuestionsHelper
  def ask_question
    button_to  'Ask Question', new_question_path,method: :get, class:" btn btn-primary pull-right"
  end

  def vote_up_question_link(question)
    link_to 'Vote Up', upvote_question_path(question), method: "post"
  end

  def vote_down_question_link(question)
    link_to 'Vote Down', downvote_question_path(question), method: "post"
  end

  def tags_of_this_question(question)
    raw question.tag_list.map { |t| link_to t, tag_path(t) }.join(', ')
  end
end
