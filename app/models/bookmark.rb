class Bookmark < ActiveRecord::Base
  belongs_to :question, class_name: "Question"
  has_and_belongs_to_many :askable
  validates :question_id, presence: true
  validates :bookmarkable_id, presence: true
  validates :bookmarkable_type, presence: true
end
