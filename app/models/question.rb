class Question < ActiveRecord::Base
	acts_as_taggable
	belongs_to :user
	has_many :answers 
	has_many :users, through: :answers, dependent: :destroy

	accepts_nested_attributes_for :answers

	def answered?
		answers.where(flag: true).count > 0
	end

	def ans_id
		answers.each do |ans|
			if ans.flag== true
				logger.debug "-------------------------#{ans.flag}"
				return ans.id
			end
		end
	end
end
