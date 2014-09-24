class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  
  has_many :answers,as: :answerable
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :questions, :through => :bookmarks
  has_many :questions,as: :askable

  VALID_EMAIL_REGEX = Student::VALID_EMAIL_REGEX

  validates :first_name,:last_name, presence: true
  validates :username,:qualification, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,length: {minimum: 8}, on: :create
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  attr_accessor :current_password
  acts_as_tagger
  acts_as_voter
  has_attached_file :avatar, :styles => { :medium => "#{Settings.paperclip.style.medium}>", :thumb => "#{Settings.paperclip.style.thumb}>" }, :default_url => Settings.paperclip.style.image_default_url
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
