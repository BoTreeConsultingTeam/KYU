class Student < ActiveRecord::Base
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  has_many :questions,as: :askable
  has_many :answers,as: :answerable
  has_many :bookmarks, as: :bookmarkable, dependent: :destroy
  has_many :questions, :through => :bookmarks

  validates :first_name,:last_name,:middle_name, presence: true
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,presence: true
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }  
   before_destroy :delete_comment

   def delete_comment
      self.bookmarks.destroy_all
   end
end
