class Question < ActiveRecord::Base

  # include Findable
  belongs_to :askable, polymorphic: true
  has_many :answers, dependent: :destroy
  has_many :students, :through => :bookmarks, :source => :bookmarkable, :source_type => "Student"
  has_many :teachers, :through => :bookmarks, :source => :bookmarkable, :source_type => "Teacher" 
  has_many :bookmarks
  has_many :comments,as: :relative,dependent: :destroy
  belongs_to :standard
  paginates_per 10
  is_impressionable
  acts_as_taggable
  acts_as_votable
  
  accepts_nested_attributes_for :answers
  scope :enabled, -> { where(:enabled => true)}
  scope :recent_data_month, -> { where(:created_at => (1.month.ago)..(Time.now)).order("created_at desc") }
  scope :recent_data_week, -> { where(:created_at => (1.week.ago)..(Time.now)).order("created_at desc")}
  scope :most_viwed_question, -> { joins(:impressions).group("questions.id").order("count(questions.id) DESC").limit(10)}
  scope :newest, ->(current_user) { where(:created_at => (current_user.last_sign_in_at)..(current_user.current_sign_in_at)).order("created_at desc")}
  validates_presence_of :title
  validates_presence_of :content
  validates :title, length: { maximum: 150, minimum: 20 }
  validates :content, length: { minimum: 1000, minimum: 20 }
  validates_presence_of :standard_id

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

  def self.send_question_answer_abuse_report(current_user, question)
    begin
      KyuMailer.delay.report_abuse_mailer(current_user, question)
    rescue Exception => e
      Rails.logger.error "Failed to send email, email address: #{current_user.email}"
      Rails.logger.error "#{e.backtrace.first}: #{e.message} (#{e.class})"
    end
  end
  def bookmark(user)
    bookmarks.create(bookmarkable: user)
  end
  
  def self.highest_voted
    self.order("cached_votes_score DESC").limit(5)
  end
end
