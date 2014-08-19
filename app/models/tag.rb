class Tag < ActiveRecord::Base
  has_many :taggings
  has_many :questions, through: :taggings, source: :taggable, source_type: Question
  has_many :answers, through: :taggings, source: :taggable, source_type: Answer

end
