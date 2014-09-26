class Student < ActiveRecord::Base
  
  include Gioco_Methods

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_destroy :delete_bookmarks
  
  devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  has_many :answers, as: :answerable
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :questions, :through => :bookmarks
  has_many :questions, as: :askable
  has_many :badges, :through => :levels 
  has_many :levels   
  belongs_to :standard
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :standard_id, presence: true
  acts_as_tagger
  acts_as_voter
  has_attached_file :avatar, :styles => { :medium => "#{Settings.paperclip.style.medium}>", :thumb => "#{Settings.paperclip.style.thumb}>" }, :default_url => Settings.paperclip.style.image_default_url
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
  def delete_bookmarks
    self.bookmarks.destroy_all
  end

  def self.student_manager_selected?
    self.where(student_manager: true).count
  end
end