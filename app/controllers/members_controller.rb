class MembersController < ApplicationController
  before_filter :find_student_by_id, only: [:deactivate, :mark_review, :unmark_student_review, :activate_student, :remove_students_manager]
  before_action :user_signed_in?
  before_action -> (user = current_administrator) { require_permission user }, only: [:edit, :destroy] 
  
  def index
    params[:active_tab_menu] = 'members'
    if params[:active_tab] == 'Teachers'
      @teachers = Kaminari.paginate_array(Teacher.all).page(params[:page]).per(Settings.pagination.per_page_12)
    elsif params[:active_tab] == 'Managers'
      @students = Kaminari.paginate_array(Student.where("student_manager = ?",true)).page(params[:page]).per(Settings.pagination.per_page_12)
    elsif params[:active_tab] == 'Students for Review'
      @students = Kaminari.paginate_array(Student.where("mark_as_review = ?",true)).page(params[:page]).per(Settings.pagination.per_page_12)
    elsif params[:active_tab] == 'Blocked Students'
      @students = Kaminari.paginate_array(Student.where("enable = ?",false)).page(params[:page]).per(Settings.pagination.per_page_12)
    else
      @all_students = Student.all
      @students = Student.all.page(params[:page]).per(Settings.pagination.per_page_12)
    end
    respond_to do |format| 
      format.html
      format.js
    end
  end

  def show
    if params[:user] == 'Student' 
      @student = Student.find_by_id(params[:id])
      @questions = @student.questions
      @answers = @student.answers
    else
      @teacher = Teacher.find(params[:id])
      @questions = @teacher.questions
      @answers = @teacher.answers
    end
  end

  def deactivate
  	if @student.update_attributes(enable: false)
  		flash[:notice] = 'Student is Blocked'
  		redirect_to members_path
  	else
  		redirect_to root_path
  	end	
  end	

  def activate_student
    if @student.update_attributes(enable: true)
      flash[:notice] = 'Student is Unblocked'
      redirect_to members_path
    else
      redirect_to root_path
    end 
  end

  def unmark_student_review
    if @student.update_attributes(mark_as_review: false)
      flash[:notice] = 'Marked as review'
      @students = Student.all
      redirect_to members_path
    else
      redirect_to root_path
    end
  end

  def mark_review
    if @student.update_attributes(mark_as_review: true)
      flash[:notice] = 'Marked as review'
      @students = Student.all
      redirect_to members_path
    else
      redirect_to root_path
    end 
  end

  def select_students_manager
    if Student.find_all_by_student_manager(true).count < Settings.students.student_manager_limit
      @student = Student.find_by_id(params[:id])
      @student.student_manager = true
      @student.save      
    else
      flash[:error] = t('flash_message.error.student.manager')
    end
    redirect_to members_path
  end

  def remove_students_manager
    @student.update_attributes(student_manager: false)
    if @student.save      
      flash[:notice] = 'Successfully removed'
    else
      flash[:error] = t('flash_message.error.student.manager')
    end
    redirect_to members_path
  end

  private

  def find_student_by_id
    @student = Student.find(params[:id])
  end  

  def received_filter
    params[:filter]
  end
end
