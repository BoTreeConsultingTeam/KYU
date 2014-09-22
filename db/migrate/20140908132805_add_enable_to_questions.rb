class AddEnableToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :enable, :boolean,default: true
  end
end
