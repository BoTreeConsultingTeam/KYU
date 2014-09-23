class AddEnableToTeachers < ActiveRecord::Migration
  def change
    add_column :teachers, :enable, :boolean,default: true
  end
end
