class Point < ActiveRecord::Base
	scope :action_score, ->(id) { Point.find(id).score}
end
