class MembersController < ApplicationController
  
  def index
    @students = Student.all.page(params[:page]).per(6)
    @teachers = Teacher.all.page(params[:page]).per(6)
  end

end
