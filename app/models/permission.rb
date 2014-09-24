class Permission < ActiveRecord::Base
  belongs_to :badge, class_name: "Badge"
  belongs_to :rule, class_name: "Rule"
end
