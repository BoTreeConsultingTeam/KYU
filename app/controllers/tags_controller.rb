class TagsController < ApplicationController
  
  def index
    @tags = ActsAsTaggableOn::Tag.all.page(params[:page]).per(5)
  end 

  def show 
    @tag = ActsAsTaggableOn::Tag
  end
  def new
     @question = Question.new
     @tag = @question.tags.new
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.update(tag_params)
      flash[:notice] = "Tag updated"
      redirect_to tags_path
    else
      render 'edit'
    end 
  end

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params )
    if @tag.save
      flash[:notice] = "Tag generated"
      redirect_to tags_path
    else
      flash[:error] = "not created"
      redirect_to tags_path
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    if @tag.destroy
      flash[:notice] = "Tag destroy"
      redirect_to tags_path
    else
      flash[:error] = "Tag not destroy"
      redirect_to tags_path
    end
  end

  private
  
  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(:name,:taggings_count, :description)
  end
end