class TagsController < ApplicationController
  before_filter :find_tag_by_id, only: [:edit, :update, :destroy]
  # after_filter :tag_redirection, only: [:create, :destroy]
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
    @tag
  end

  def update
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
    else
      flash[:error] = "not created"
    end
    tag_redirection
  end

  def destroy
    if @tag.destroy
      flash[:notice] = "Tag destroy"
    else
      flash[:error] = "Tag not destroy"
    end
    tag_redirection
  end

  private
  
  def tag_params
    params.require(:acts_as_taggable_on_tag).permit(:name,:taggings_count, :description)
  end

  def find_tag_by_id
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
  end  

  def tag_redirection
    redirect_to tags_path
  end  
end