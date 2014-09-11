class AddPointsToStudents < ActiveRecord::Migration
  def change
    add_column :students, :points, :integer
  end
end
