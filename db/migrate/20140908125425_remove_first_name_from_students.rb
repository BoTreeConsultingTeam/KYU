class RemoveFirstNameFromStudents < ActiveRecord::Migration
  def change
    remove_column :students, :first_name, :string
  end
end
