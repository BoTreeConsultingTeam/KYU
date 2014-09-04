module AnswersHelper
  
  def vote_answer_link(answer,vote)
    if 'up'== vote
      css_class = "action vote vote-up img-circle fa fa-chevron-up"
    else
      css_class = "action vote vote-up img-circle fa fa-chevron-down"
    end
    link_to '', vote_answer_path(answer,type: vote), method: "post", class: css_class,remote: true
  end
end
