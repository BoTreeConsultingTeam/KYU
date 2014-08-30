module AnswersHelper
  
  def vote_up_answer_link(question)
    link_to '', upvote_answer_path(question), method: "post", class: 'action vote vote-up img-circle fa fa-chevron-up'
  end

  def vote_down_answer_link(question)
    link_to '', downvote_answer_path(question), method: "post",class: 'action vote vote-down img-circle fa fa-chevron-down'
  end
end
