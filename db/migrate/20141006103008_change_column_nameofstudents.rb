class ChangeColumnNameofstudents < ActiveRecord::Migration
  def change
    rename_column :students, :division, :division_id
  end
end
