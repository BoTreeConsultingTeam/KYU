class Teacher < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :comments, as: :commentable
  has_many :questions,as: :askable
  has_many :answers,as: :answerable
  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :first_name,:last_name, presence: true
  validates :username,:qualification, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,length: {minimum: 8}, on: :create
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  attr_accessor :current_password
end
