class Permissions < ActiveRecord::Migration
  def change
  create_table :permissions do |t|
    t.integer :badge_id
    t.integer :rule_id

    t.timestamps
  end
  add_index :permissions, :badge_id
  add_index :permissions, :rule_id
  add_index :permissions, [:badge_id, :rule_id], unique: true
  end
end
