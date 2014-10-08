class AddDivisionToStudents < ActiveRecord::Migration
  def change
    add_column :students, :division, :integer
  end
end
