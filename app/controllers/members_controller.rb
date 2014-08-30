class MembersController < ApplicationController
  
  def index
    @students = Student.all.page params[:page]
  end

  def show
    @student = Student.find(params[:id])
  end

end
