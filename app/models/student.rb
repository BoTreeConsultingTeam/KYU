  class Student < ActiveRecord::Base

  include Gioco_Methods

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  
  before_destroy :delete_bookmarks
  
  devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  
  has_many :answers,as: :answerable
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :questions, :through => :bookmarks
  has_many :questions,as: :askable
  has_many :badges, :through => :levels 
  has_many :levels   
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,presence: true
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  acts_as_tagger

   def delete_bookmarks
      self.bookmarks.destroy_all
   end
end
