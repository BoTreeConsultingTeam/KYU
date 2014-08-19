class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.string :title
      t.string :title_alias

      t.timestamps
    end
  end
end
