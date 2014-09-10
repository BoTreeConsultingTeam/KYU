class TagsController < ApplicationController
  
  def index
    @tags = ActsAsTaggableOn::Tag.all
    questions = Questions.all
  end 

  def show 
    @tag = ActsAsTaggableOn::Tag
  end
  
  private
  
  def tag_params
    params.require(:tag).permit(:name,:taggings_count)
  end
end