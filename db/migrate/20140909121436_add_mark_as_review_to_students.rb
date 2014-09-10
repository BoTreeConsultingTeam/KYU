class AddMarkAsReviewToStudents < ActiveRecord::Migration
  def change
    add_column :students, :mark_as_review, :boolean,default: false
  end
end
