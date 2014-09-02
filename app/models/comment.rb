class Comment < ActiveRecord::Base
  
  include Findable
  include ActsAsCommentable::Comment
  belongs_to :question
  belongs_to :answer
  belongs_to :relative, :polymorphic => true
  belongs_to :commentable, :polymorphic => true
  scope :relative_comments, ->(relative_id,relative_class) {where("relative_id = ? AND relative_type = ?",relative_id,relative_class)}
  scope :all_comments_of_answers, -> (relative_type) {where("relative_type = ?",relative_type)}
  validates :comment, presence: true, length: { maximum: 30 }

  def is_author?(user)
   self.commentable == user
  end
end
