class Division < ActiveRecord::Base
  has_many :standards, through: :standard_divisions
  has_many :standard_divisions
  has_many :students
end
