class Question < ActiveRecord::Base
	acts_as_taggable
	acts_as_votable
	belongs_to :user
	belongs_to :student
	belongs_to :teacher
	has_many :answers 
	has_many :users, through: :answers, dependent: :destroy

	accepts_nested_attributes_for :answers
end
