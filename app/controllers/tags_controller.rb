class TagsController < ApplicationController
  before_filter :find_tag_by_id, only: [:edit, :update, :destroy]
  before_action :admin_signin?, only:[:new, :edit, :destroy]

  # after_filter :tag_redirection, only: [:create, :destroy]
  def index
    params[:active_tab_menu] = 'alltags'
    @tags = Kaminari.paginate_array(ActsAsTaggableOn::Tag.all).page(params[:page]).per(Settings.pagination.per_page_6)
  end 

  def show 
    @tag = ActsAsTaggableOn::Tag
  end
  def new
    @question = Question.new
    @tag = @question.tags.new
  end

  def edit
    if (current_administrator)
      @tag
    else
      flash[:error] = t('common.messages.unauthorized')
      redirect_to root_path
    end
  end

  def update
    if @tag.update(tag_params)
      flash[:notice] = t('tags.message.update_success')
      redirect_to tags_path
    else
      render 'edit'
    end 
  end

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params )
    if @tag.save
      flash[:notice] = t('tags.message.create_success')
    else
      flash[:error] = t('tags.message.create_failure')
    end
    tag_redirection
  end

  def destroy
    if @tag.destroy
      flash[:notice] = t('tags.message.destroy_success')
    else
      flash[:error] = t('tags.message.destroy_failure')
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