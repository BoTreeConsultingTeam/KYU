class AddHighestQualificationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :highest_qualification, :string
  end
end
