class AddClassColumnToStudent < ActiveRecord::Migration
  def change
    add_column :students, :student_class, :string
  end
end
