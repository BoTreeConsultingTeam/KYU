class MembersController < ApplicationController
  
  def index
    @student_manager = Student.where("student_manager = ?",true)
    @students = Student.all.page(params[:page]).per(6)    
  end

  def show
    @student = Student.find_by_id(params[:id])
  end

  def studentclass

  end

  def students_manager
    if Student.where(student_manager: true).count < 2
      @student = Student.find_by_id(params[:id])
      @student.student_manager = true
      @student.save
      redirect_to members_path
    else
      redirect_to members_path,flash: { error: t('flash_massege.error.student.manager') }
    end
    
  end
end
