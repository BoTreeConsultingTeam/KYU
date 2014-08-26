class AddColumnToQuestion < ActiveRecord::Migration
  def change
  	change_table :questions do |t|
      t.references :askable, :polymorphic => true
    end
  end
end
