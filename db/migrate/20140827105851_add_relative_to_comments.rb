class AddRelativeToComments < ActiveRecord::Migration
  def change
  	change_table :comments do |t|
      t.references :relative, :polymorphic => true
    end
  end
end
