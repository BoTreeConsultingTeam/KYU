class Question < ActiveRecord::Base

  belongs_to :user
  belongs_to :student
  belongs_to :teacher
  belongs_to :askable, polymorphic: true
  has_many :answers
  has_many :users, through: :answers, dependent: :destroy
  paginates_per 10
  is_impressionable
  acts_as_taggable
  acts_as_votable
  accepts_nested_attributes_for :answers

  # default_scope order("created_at DESC")
  scope :recent_data_month, -> { where(:created_at => (1.month.ago)..(Time.now)).order("created_at desc") }
  scope :recent_data_week, -> { where(:created_at => (1.week.ago)..(Time.now)).order("created_at desc")}
  scope :most_viwed_question, -> { joins(:impressions).group("questions.id").order("count(questions.id) DESC").limit(10)}
  scope :newest, ->(current_user) { where(:created_at => (current_user.last_sign_in_at)..(current_user.current_sign_in_at)).order("created_at desc")}
  validates_presence_of :title
  validates_presence_of :content
  validates :title, length: { maximum: 150, minimum: 20 }
  validates :content, length: { maximum: 1000, minimum: 20 }
  
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
  def self.highest_voted
    self.order("cached_votes_score DESC").limit(5)
  end
end
