class CreateStandardDivisions < ActiveRecord::Migration
  def change
    create_table :standard_divisions do |t|
      t.integer :standard_id
      t.integer :division_id

      t.timestamps
    end
  end
end
