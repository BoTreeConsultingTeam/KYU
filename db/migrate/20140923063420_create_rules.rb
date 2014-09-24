class CreateRules < ActiveRecord::Migration
  def change
    create_table :rules do |t|
      t.string :description

      t.timestamps
    end
  end
end
