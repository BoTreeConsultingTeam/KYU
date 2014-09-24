class Badge < ActiveRecord::Base

  include Gioco_Methods
  default_scope order("points ASC")
  has_many :students, :through => :levels 
  has_many :levels  , :dependent => :destroy
  has_many :rules,  :through => :permissions
  has_many :permissions
  validates_presence_of :name
  validates_presence_of :points

  def give_permission(rule)
  	permissions.create(rule_id: rule.id)
  end
end
