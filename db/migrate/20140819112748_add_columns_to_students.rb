class AddColumnsToStudents < ActiveRecord::Migration
  def change
  	add_column :students, :first_name, :string
  	add_column :students, :middle_name, :string
  	add_column :students, :last_name, :string
  	add_column :students, :username, :string
  	add_column :students, :birthdate, :date

  end
end
