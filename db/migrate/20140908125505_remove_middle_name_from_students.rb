class RemoveMiddleNameFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :middle_name, :string
  end
end
