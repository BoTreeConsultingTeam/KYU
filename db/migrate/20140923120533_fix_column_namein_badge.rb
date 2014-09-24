class FixColumnNameinBadge < ActiveRecord::Migration
  def change
  	rename_column :badges, :flag, :default
  end
end
