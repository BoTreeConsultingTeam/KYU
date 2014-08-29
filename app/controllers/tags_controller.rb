class TagsController < ApplicationController
  def index
  	@tags = ActsAsTaggableOn::Tag.all  	
  end	

  def show
  		if params[:id].present? 
           @question = Question.tagged_with(params[:id])
        end
  end

  private
  def tag_params
    params.require(:tag).permit(:name,:taggings_count)
  end
end