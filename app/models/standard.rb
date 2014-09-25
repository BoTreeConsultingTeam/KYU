class Standard < ActiveRecord::Base
	has_many :students
	has_many :questions
	has_many :divisions, through: :standard_divisions
	has_many :standard_divisions
end
