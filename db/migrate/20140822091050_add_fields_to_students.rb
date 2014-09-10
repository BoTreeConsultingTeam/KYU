class AddFieldsToStudents < ActiveRecord::Migration
  def self.up
    add_column :students, :sash_id, :integer
    add_column :students, :level, :integer, :default => 0
  end

  def self.down
    remove_column :students, :sash_id
    remove_column :students, :level
  end
end
