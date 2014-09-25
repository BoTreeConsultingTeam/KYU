class Rule < ActiveRecord::Base
  has_many :badges,  through:  :permissions
end
