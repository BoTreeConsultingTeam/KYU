class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.string :class_no

      t.timestamps
    end
  end
end
