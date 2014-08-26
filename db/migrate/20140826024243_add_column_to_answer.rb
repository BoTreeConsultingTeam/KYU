class AddColumnToAnswer < ActiveRecord::Migration
  def change
  	change_table :answers do |t|
      t.references :answerable, :polymorphic => true
    end
  end
end
