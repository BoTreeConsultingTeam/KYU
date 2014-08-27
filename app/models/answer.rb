class Answer < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :answerable, polymorphic: true
  acts_as_votable

  validates_presence_of :content
  validates :content, length: { maximum: 1000 }
end
