class ReportsController < ApplicationController
  before_action :set_student, only: [:find_report]
  before_action :set_standard, only: [:student_activeness, :students_questions_compare,:students_questions_compare,:students_answers_compare]
  before_filter :division_list, only: [:index, :student_activeness, :students_questions_compare, :students_answers_compare]
  before_filter :set_division, only: [:student_activeness, :students_questions_compare, :students_answers_compare]

  def index
    @students = Student.all
    @standards = Standard.all
    @tags = ActsAsTaggableOn::Tag.all
    if params[:active_tab] == 'Class Activeness'
      @questions = @standards.map{|standard| [standard.class_no, standard.questions.count]}
      @class_activity_bar_chart = GoogleChartService.render_reports_charts( @questions, :bar, "Questions asked by each Class ", :true, 'Questions', 'Class', false)
    elsif params[:active_tab] == 'Used Tags'
      @tags_usage_table = @tags.map{|tag|[tag.name,Question.tagged_with(tag).count]}
      @tags_usage_chart = GoogleChartService.render_reports_charts( @tags_usage_table, :pie, "Used tags by all students", true, 'Tag', 'Count', false)
    else
      @questions = @standards.map{|standard| [standard.class_no, standard.questions.count]}
      @class_activity_bar_chart = GoogleChartService.render_reports_charts( @questions, :bar, "Questions asked by each Class ", :true, 'Questions', 'Class', false)
    end
    respond_to do |format|
      format.html
      format.js
    end
  end

  def search_reports
    @active_tab = params[:active_tab]
    respond_to do |format|
      format.js {
        render file: 'reports/index'
      }
    end
  end

  def find_report
    @report_name = params[:report_name]
    if @report_name == 'Strength'
      @accepted_answers = @student.answers.accepted_answers
      @question_ids = @accepted_answers.map {|obj| obj.question_id}
      @students_tags = prepate_chart(@question_ids,0)

    elsif @report_name == 'Weakness'
      @question_ids = @student.questions.map {|obj| obj.id}
      @students_tags = prepate_chart(@question_ids,0)

    elsif @report_name == 'Top 3 Weak Area'
      @question_ids = @student.questions.map {|obj| obj.id}
      @top_3_area = prepate_chart(@question_ids,1)

    elsif @report_name == 'Top 3 Strong Area'
      @accepted_answers = @student.answers.accepted_answers
      @question_ids = @accepted_answers.map {|obj| obj.question_id}
      @top_3_area = prepate_chart(@question_ids,1)
    end

    respond_to do |format|
      format.js {
        render file: 'reports/index'
      }
    end
  end

  def update_students
    standard = Standard.find(params[:standard_id])
    @students = standard.students.map{|a| [a.username, a.id]}.insert(0, t('report.caption.select_artist'))
  end

  # def class_activity
  #   @standards =Standard.all
  #   if @standards.nil?
  #     error_message
  #   else
  #     @questions = @standards.map{|standard| [standard.class_no, standard.questions.count]}
  #     @class_activity_bar_chart = GoogleChartService.render_reports_charts( @questions, :bar, "Questions asked by each Class ", :true, 'Questions', 'Class', false)
  #     puts "-----------------#{@class_activity_bar_chart.inspect}"
  #   end
  # end

  # def student_weakness
  #   if !@student.questions.blank?
  #     @question_ids = @student.questions.map {|obj| obj.id}
  #     @students_tags = prepate_chart(@question_ids,0)

  #   else
  #     error_message
  #   end
  # end

  # def student_strength
  #   if @student.answers.blank?
  #     error_message
  #   else
  #     @accepted_answers = @student.answers.accepted_answers
  #     @question_ids = @accepted_answers.map {|obj| obj.question_id}
  #     @students_tags = prepate_chart(@question_ids,0)
  #   end
  # end

  # def tags_usage
  #   @tags = ActsAsTaggableOn::Tag.all
  #   if @tags.blank?
  #     error_message
  #   else
  #     @tags_usage_table = @tags.map{|tag|[tag.name,Question.tagged_with(tag).count]}
  #     @tags_usage_chart = GoogleChartService.render_reports_charts( @tags_usage_table, :pie, "Tags Usage", true, 'Tag', 'Count', false)
  #   end
  # end

  def student_activeness
    if @standard.students.blank? || @division.students.blank?
      error_message
    else
      @student_activeness_table = Student.where('standard_id = ? and division_id = ?',params[:standard_id], params[:division_id]).map{|student|[student.username,student.sign_in_count]}
      @student_activeness_chart = GoogleChartService.render_reports_charts( @student_activeness_table, :bar, "Student login counts", true, 'Name', 'Login Count',false)
    end
  end

  def students_questions_compare
    if @standard.students.blank? || @division.students.blank?
      error_message
    else
      @students_questions_compare_table = Student.where('standard_id = ? and division_id = ?',params[:standard_id], params[:division_id]).map{|student|[student.username,student.questions.count]}
      @students_questions_compare_chart = GoogleChartService.render_reports_charts(@students_questions_compare_table, :bar, "Questions asked by students", true, 'Name', 'Question Count',false)
    end
  end

  def students_answers_compare
    if @standard.students.blank? || @division.students.blank?
      error_message
    else
      @students_answers_compare_table = Student.where('standard_id = ? and division_id = ?',params[:standard_id], params[:division_id]).map{|student|[student.username,student.answers.count]}
      @students_answers_compare_chart = GoogleChartService.render_reports_charts(@students_answers_compare_table, :bar, "Answers given by students", true,'Name','Answers Count',false)
    end
  end

  # def top_3_weak_area
  #   if !@student.questions.blank?
  #     @question_ids = @student.questions.map {|obj| obj.id}
  #     @top_3_area = prepate_chart(@question_ids,1)
  #   else
  #     error_message
  #   end
  # end

  # def top_3_strong_area
  #   if !@student.answers.blank?
  #     @accepted_answers = @student.answers.accepted_answers
  #     @question_ids = @accepted_answers.map {|obj| obj.question_id}
  #     @top_3_area = prepate_chart(@question_ids,1)
  #   else
  #     error_message
  #   end
  # end

  def divisions_by_standard
    @report_type = params[:form]
    @standard = Standard.find_by_id(params[:standard_id])
    @divisions = @standard.divisions
    respond_to do |format|
      format.js
    end
  end

  private

    def set_student
      @student  = Student.find_by_email(params[:email])
      if @student.nil?
        flash[:error] = t('flash_message.error.report.no_student')
        redirect_to reports_path
      end
    end

    def set_standard
      @standard = Standard.find_by_id(params[:standard_id])
      if @standard.nil?
        flash[:error] = t('flash_message.error.report.no_standard')
        redirect_to reports_path
      end
    end

    def set_division
      @division = Division.find_by_id(params[:division_id])
      if @division.nil?
        flash[:error] = t('flash_message.error.report.no_standard')
        redirect_to reports_path
      end
    end

    def error_message
      flash[:error] = t('flash_message.error.report.no_student')
      redirect_to reports_path
    end

    def prepate_chart(question_ids, flag)
      tag_ids_of_question = ActsAsTaggableOn::Tagging.find_all_by_taggable_id(question_ids).map { |obj| obj.tag_id }
      students_tags = tag_ids_of_question.group_by{|tag_id| tag_id}.map{|tag_id,tag_count| [ ActsAsTaggableOn::Tag.find_all_by_id(tag_id).map {|obj| obj.name}, tag_count.count].flatten }
      sorted_reverse_array = students_tags.sort {|a,b| a[1] <=> b[1]}.reverse
      first_3_elements = sorted_reverse_array.slice(0,3)
      if flag == 1
        @chart = GoogleChartService.render_reports_charts( first_3_elements, :bar, "Student's tag ration", true, 'Tag', 'Count', false )
        first_3_elements
      else
        @chart = GoogleChartService.render_reports_charts( students_tags, :bar, "Student's tag rtaion", true, 'Tag', 'Count', false )
        students_tags
      end
    end

  def division_list
    @divisions = Division.all
  end
end