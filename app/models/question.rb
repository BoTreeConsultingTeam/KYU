class Question < ActiveRecord::Base
  
  paginates_per 10

  scope :recent_data_month, where(:created_at => (1.month.ago)..(Time.now)).order("created_at desc")
  scope :recent_data_week, where(:created_at => (1.week.ago)..(Time.now)).order("created_at desc")
  scope :all_data, Question.all.order("created_at desc")
  
  is_impressionable
  
  acts_as_taggable
  belongs_to :user
  has_many :answers 
  has_many :users, through: :answers, dependent: :destroy

  accepts_nested_attributes_for :answers
end
