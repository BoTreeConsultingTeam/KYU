class Student < ActiveRecord::Base

  include Gioco_Methods

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  has_many :badges, :through => :levels 
  has_many :levels   
  has_many :comments, as: :commentable
  has_many :questions,as: :askable
  has_many :answers,as: :answerable
  VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username,:birthdate, presence: true
  validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password,presence: true, on: :create
  validates_confirmation_of :password, if: lambda { |m| m.password.present? }
  attr_accessor :current_password
end
