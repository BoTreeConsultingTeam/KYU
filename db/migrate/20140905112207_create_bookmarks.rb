class CreateBookmarks < ActiveRecord::Migration
  def change
  create_table :bookmarks do |t|
    t.integer :question_id
    t.references :bookmarkable, :polymorphic => true
  end
    add_index :bookmarks, [:question_id, :bookmarkable_id, :bookmarkable_type], unique: true, name: 'bookmarks_index'
  end
end
