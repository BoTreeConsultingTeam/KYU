class Student < ActiveRecord::Base
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
   :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  has_many :questions,as: :askable
  has_many :answers,as: :answerable
  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name,:last_name,:middle_name, presence: true
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,presence: true
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  acts_as_tagger

end
