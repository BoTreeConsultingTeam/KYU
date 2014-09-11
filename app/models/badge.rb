class Badge < ActiveRecord::Base
 
  include Gioco_Methods
  has_many :students, :through => :levels 
  has_many :levels  , :dependent => :destroy
  validates :name, :presence => true
end
