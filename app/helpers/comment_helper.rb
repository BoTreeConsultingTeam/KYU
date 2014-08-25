module CommentHelper
	def comments_of_this_question
      commentable = Comment.where(["commentable_id = ?",@question.id])     
	end

end