class RemoveLastNameFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :last_name, :string
  end
end
