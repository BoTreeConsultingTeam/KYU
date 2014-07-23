class User < ActiveRecord::Base
  attr_accessible :gr_number, :first_name, :middle_name, :last_name, :date_of_birth, :email, :password

  validates_presence_of :gr_number, message: "is required"
  validates_presence_of :first_name, message: "is required"
  validates_presence_of :middle_name, message: "is required"
  validates_presence_of :last_name, message: "is required"
  validates_presence_of :date_of_birth, message: "is required"
  validates_presence_of :email, message: "is required"
  validates_presence_of :password, message: "is required"

end
