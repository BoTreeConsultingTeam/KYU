class Student < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable\
  has_many :questions
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         validates :first_name,:last_name,:middle_name, presence: true
    validates :username,:birthdate, presence: true
 	VALID_EMAIL_REGEX=/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
    validates :password,presence: true
    validates_confirmation_of :password, if: lambda { |m| m.password.present? }
    
end
