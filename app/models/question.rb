class Question < ActiveRecord::Base
  
  include Findable
	acts_as_taggable
	acts_as_votable
	belongs_to :user
	has_many :comments,as: :relative,dependent: :destroy
	has_many :answers
  belongs_to :askable, polymorphic: true
	accepts_nested_attributes_for :answers
  
  def answered?
    answers.where(flag: true).count > 0
  end

  def accepted_answer_id
    answers.each do |ans|
      if ans.flag == true
        return ans.id
      end
    end
  end
end
