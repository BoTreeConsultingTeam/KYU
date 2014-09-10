class Question < ActiveRecord::Base
  
  include Findable
  belongs_to :askable, polymorphic: true
  has_many :answers, dependent: :destroy
  paginates_per 10
  is_impressionable
  acts_as_taggable
  acts_as_votable
  has_many :comments,as: :relative,dependent: :destroy
  accepts_nested_attributes_for :answers
  scope :recent_data_month, -> { where(:created_at => (1.month.ago)..(Time.now)).order("created_at desc") }
  scope :recent_data_week, -> { where(:created_at => (1.week.ago)..(Time.now)).order("created_at desc")}

  validates_presence_of :title
  validates_presence_of :content
  validates :title, length: { maximum: 150, minimum: 20 }
  validates :content, length: { maximum: 1000, minimum: 20 }
  default_scope where("enable = ?",true)
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
end
