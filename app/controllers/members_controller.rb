class MembersController < ApplicationController
  before_filter :find_student_by_id, only: [:show, :deactivate, :mark_review]
  def index
    @students = Student.all.page(params[:page]).per(5)
    @teachers = Teacher.all.page(params[:page]).per(5)
  end

  def show
    if params[:user] == 'student'
      @student
      @questions = @student.questions
      @answers = @student.answers
    else
      @teacher = Teacher.find(params[:id])
    end
  end

  def deactivate
  	if @student.update_attributes(enable: false)
  		flash[:notice] = 'Student is Blocked'
  		redirect_to members_path(users: "students")
  	else
  		redirect_to root_path
  	end	
  end	

  def mark_review
    if @student.update_attributes(mark_as_review: true)
      flash[:notice] = 'Marked as review'
      redirect_to members_path(users: "students")
    else
      redirect_to root_path
    end 
  end 

  private

  def find_student_by_id
    @student = Student.find(params[:id])
  end  

  def received_filter
    params[:filter]
  end

end
