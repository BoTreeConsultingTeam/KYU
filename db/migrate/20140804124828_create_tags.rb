class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :title
      t.string :title_alias

      t.timestamps
    end
  end
end
