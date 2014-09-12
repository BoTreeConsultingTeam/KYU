class Level < ActiveRecord::Base
  belongs_to :badge  
  belongs_to :student  
end
