class Answer < ActiveRecord::Base
	belongs_to :question
  	belongs_to :user
  	has_many :comments,as: :relative,dependent: :destroy
  	acts_as_votable
  	belongs_to :answerable, polymorphic: true
  	default_scope -> { order('created_at DESC') }
end
