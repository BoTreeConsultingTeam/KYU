class AddColumnToBadges < ActiveRecord::Migration
  def change
  	add_column :badges, :color, :string
  end
end
