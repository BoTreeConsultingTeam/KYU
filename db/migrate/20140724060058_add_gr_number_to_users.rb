class AddGrNumberToUsers < ActiveRecord::Migration
  def change
    add_column :users, :gr_number, :string
  end
end
