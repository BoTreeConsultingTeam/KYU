module CommentHelper
  def comments_of_this_question
    commentable = Comment.where("relative_id = ? AND relative_type = ?",@question.id,@question.class)
  end

  def comments_of_this_answer
    commentable = Comment.where(["relative_id = ? AND relative_type = ?",@answer.id,@answer.class])
  end

  def comments_of_all_answers   
    commentable = Comment.where(["relative_type = ?","Answer"])
  end

end