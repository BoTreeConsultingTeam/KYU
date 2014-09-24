class AddColumnActionToPoints < ActiveRecord::Migration
  def change
    add_column :points, :action, :string
  end
end
