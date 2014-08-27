module AnswersHelper
  
  def vote_up_answer_link(question)
    link_to 'Vote Up', upvote_answer_path(question), method: "post"
  end

  def vote_down_answer_link(question)
    link_to 'Vote Down', downvote_answer_path(question), method: "post"
  end
end
