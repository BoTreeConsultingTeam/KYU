class AddStandardToQuestion < ActiveRecord::Migration
  def change
  	add_column :questions, :standard_id, :integer
  end
end
