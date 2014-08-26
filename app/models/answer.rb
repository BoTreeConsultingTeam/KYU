class Answer < ActiveRecord::Base
	belongs_to :question
  	belongs_to :user
  	acts_as_votable
  	belongs_to :answerable, polymorphic: true
end
