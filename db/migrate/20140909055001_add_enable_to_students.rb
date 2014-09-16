class AddEnableToStudents < ActiveRecord::Migration
  def change
    add_column :students, :enable, :boolean,default: true
  end
end
