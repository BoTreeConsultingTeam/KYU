class Question < ActiveRecord::Base
	acts_as_taggable
	belongs_to :user
	has_many :answers 
	has_many :users, through: :answers, dependent: :destroy

	accepts_nested_attributes_for :answers
end
