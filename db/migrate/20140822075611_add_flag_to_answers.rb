class AddFlagToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :flag, :boolean, :default => false
  end
end
