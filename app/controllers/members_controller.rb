class MembersController < ApplicationController
  
  def index
    @students = Student.all.page(params[:page]).per(5)
  end

  def show
    @student = Student.find(params[:id])
  end

  def deactivate
  	@student = Student.find(params[:id])
  	if @student.update_attributes(enable: false)
  		flash[:notice] = 'Student is Blocked'
  		redirect_to members_path
  	else
  		redirect_to root_path
  	end	
  end	

end
