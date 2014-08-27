class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :answerable, polymorphic: true
  acts_as_votable
end
