class Question < ActiveRecord::Base

  paginates_per 10
  is_impressionable
  acts_as_taggable
  acts_as_votable
  belongs_to :user
  belongs_to :student
  belongs_to :teacher
  has_many :answers
  has_many :users, through: :answers, dependent: :destroy
  belongs_to :askable, polymorphic: true
  accepts_nested_attributes_for :answers

  default_scope order("created_at DESC")

  scope :recent_data_month, -> { where(:created_at => (1.month.ago)..(Time.now)).order("created_at desc") }
  scope :recent_data_week, -> { where(:created_at => (1.week.ago)..(Time.now)).order("created_at desc")}

  def answered?
    answers.where(flag: true).count > 0
  end

  def ans_id
    answers.each do |ans|
      if ans.flag == true
        return ans.id
      end
    end
  end

  def self.in_search(search)
      if search.present?
        question = Question.tagged_with("#{search}")
      else
        scoped
      end
  end
end
