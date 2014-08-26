class TagsController < ApplicationController
  def index
  	@tags = ActsAsTaggableOn::Tag.all
  	
  end	


  private
  def tag_params
    params.require(:tag).permit(:name,:taggings_count)
  end
end