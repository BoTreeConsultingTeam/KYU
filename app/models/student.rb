  class Student < ActiveRecord::Base

  paginates_per 10
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
  belongs_to :standard
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :standard_id,presence: true
  validates :password,presence: true
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }  

   

   def delete_bookmarks
      self.bookmarks.destroy_all
   end
end
