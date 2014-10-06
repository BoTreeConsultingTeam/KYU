class StandardDivision < ActiveRecord::Base
  belongs_to :standard, class_name: 'Standard'
  belongs_to :division, class_name: 'Division'
end