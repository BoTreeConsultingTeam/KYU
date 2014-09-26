class BadgesController < ApplicationController
  before_action :user_signed_in?
  before_action :find_badge, only: [:edit, :update, :destroy]
  before_filter :find_all_rules, only: [:index, :edit, :new, :create]
  def index
    @badges = Badge.all
    @points = Point.all
  end
  
  def new
    @badge = Badge.new
  end

  def create
    @badge = Badge.new(badge_params)
    if @badge.save
      rule_ids = params[:rule_id]
      rule_ids.each do |rule_id|
      @badge.permissions.create(rule_id: rule_id )
      end
      flash[:notice] = t('badges.message.badge_create_success')
      redirect_to badges_path
    else
      flash[:error] = t('badges.message.badge_create_fail')
      render 'new'
    end  
  end

  def edit
    @badge_rules =  @badge.rules
  end

  def update
    current_access = @badge.permissions.map{|permission|permission.rule_id}
    rule_ids = params[:rule_id]
    destroy_permission rule_ids, current_access 
    create_permission rule_ids
    if @badge.update(badge_params)
      flash[:notice] = t('badges.message.badge_update_success')
      redirect_to badges_path
    else
      render 'edit'
    end 
  end

  def destroy
    if @badge.destroy
      flash[:notice] = t('badges.message.badge_destroy_success')
    else
      flash[:error] = t('badges.message.badge_destroy_fail')
    end
    redirect_to badges_path
  end

  private
  
  def badge_params
    params.require(:badge).permit(:name, :points, :default, :color)
  end

  def find_badge
    @badge = Badge.find_by_id(params[:id])
  end

  def find_all_rules
    @rules = Rule.all
  end

  def destroy_permission rule_ids, current_access 
    current_access.each do |access_id|
      if !rule_ids.include? access_id 
        @badge.permissions.find_by_rule_id(access_id).destroy
      end
    end
  end
  def create_permission rule_ids
    if !rule_ids.nil?
      rule_ids.each do |rule_id|
        if !@badge.permissions.find_by_rule_id(rule_id)
          @badge.permissions.create(rule_id: rule_id)
        end
      end
    end
  end
end