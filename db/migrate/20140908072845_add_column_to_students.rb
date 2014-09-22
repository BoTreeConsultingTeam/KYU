class AddColumnToStudents < ActiveRecord::Migration
  def change
    add_column :students, :manager, :boolean,default: false
  end
end
