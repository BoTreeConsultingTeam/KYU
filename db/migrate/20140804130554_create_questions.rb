class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :user_id
      t.integer :category_id
      t.integer :grade_id
      t.string :title
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
