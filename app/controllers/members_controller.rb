class MembersController < ApplicationController
  
  def index
    @students = Student.all.page(params[:page]).per(5)
  end

  def show
    @student = Student.find(params[:id])
  end

  def show
    @student = Student.find(params[:id])
  end
end
