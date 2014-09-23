class ChangeColumnName < ActiveRecord::Migration
  def change
    rename_column :students, :manager, :student_manager
  end
end
