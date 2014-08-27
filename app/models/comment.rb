class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  belongs_to :question
  belongs_to :answer
  belongs_to :commentable, :polymorphic => true
  belongs_to :relative, :polymorphic => true
  default_scope -> { order('created_at DESC') }

  validates :comment, presence: true, length: { maximum: 30 }
  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable

  # NOTE: Comments belong to a user
  belongs_to :user, class_name: 'Student'
end
