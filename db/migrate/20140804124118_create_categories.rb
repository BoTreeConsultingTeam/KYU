class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :title
      t.string :title_alias

      t.timestamps
    end
  end
end
