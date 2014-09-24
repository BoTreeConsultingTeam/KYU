class PointsController < ApplicationController
  before_action :set_point, only: [:update, :edit]
  def edit
    @point = Point.find(params[:id])
  end

  def update
    
    @point.update(point_params)
    if @point.save
      flash[:notice] = t('points.message.update_success')
    else
      flash[:error] = t('points.message.update_failed')
    end
    redirect_to badges_path
  end

  private

  def point_params
    params.require(:point).permit(:score)
  end

  def set_point
    @point = Point.find(params[:id])
  end
end