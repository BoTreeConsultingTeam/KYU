class Comment < ActiveRecord::Base

  include ActsAsCommentable::Comment
  belongs_to :question
  belongs_to :answer
  belongs_to :relative, :polymorphic => true
  belongs_to :commentable, :polymorphic => true

  default_scope -> { order('created_at DESC') }

  # NOTE: install the acts_as_votable plugin if you
  # want user to vote on the quality of comments.
  #acts_as_voteable
  validates :comment, presence: true, length: { maximum: 30 }
  # NOTE: Comments belong to a user
  belongs_to :user
end
