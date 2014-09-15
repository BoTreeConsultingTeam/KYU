class MembersController < ApplicationController
  def index
    @students = Student.all.page(params[:page]).per(6)    
  end

  def show
    @student = Student.find_by_id(params[:id])
    @questions = @student.questions
    @answers = @student.answers
  end

  def select_students_manager
    if Student.find_all_by_student_manager(true).count < 2
      @student = Student.find_by_id(params[:id])
      @student.student_manager = true
      @student.save      
    else
      flash[:error] = t('flash_message.error.student.manager')
    end
    redirect_to members_path
  end
  private

	def received_filter
		params[:filter]
	end
end
