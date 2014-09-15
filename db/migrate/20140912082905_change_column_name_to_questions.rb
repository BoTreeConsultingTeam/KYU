class ChangeColumnNameToQuestions < ActiveRecord::Migration
  def change
    rename_column :questions, :enable, :enabled
  end
end
