class Bookmark < ActiveRecord::Base
  belongs_to :bookmarkable, :polymorphic => true 
  belongs_to :question, class_name: "Question"
end
