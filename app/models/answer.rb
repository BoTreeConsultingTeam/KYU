class Answer < ActiveRecord::Base
  
  include Findable
  acts_as_votable
  belongs_to :question
  belongs_to :user
  has_many :comments,as: :relative,dependent: :destroy
  acts_as_votable
  belongs_to :answerable, polymorphic: true
end
