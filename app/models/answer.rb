class Answer < ActiveRecord::Base
	belongs_to :question
  	belongs_to :user
  	has_many :comments,as: :relative,dependent: :destroy
end
