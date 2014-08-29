class Teacher < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  has_many :questions, as: :askable
  has_many :answers, as: :answerable
  has_many :comments, as: :commentable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
    VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  	validates :first_name,:last_name, presence: true
    validates :username,:qualification, presence: true
  	validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    validates :password,length: {minimum: 8}
    validates_confirmation_of :password, if: lambda { |m| m.password.present? }
end
