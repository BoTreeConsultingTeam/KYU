class Question < ActiveRecord::Base
	acts_as_taggable
	# acts_as_commentable
	belongs_to :user
	has_many :comments,as: :relative,dependent: :destroy
	has_many :answers

	accepts_nested_attributes_for :answers
end
