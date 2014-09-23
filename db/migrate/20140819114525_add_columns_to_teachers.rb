class AddColumnsToTeachers < ActiveRecord::Migration
  def change
  	add_column :teachers, :first_name, :string
  	
  	add_column :teachers, :last_name, :string

  	add_column :teachers, :username, :string
  	
  	add_column :teachers, :qualification, :string
  end
end
