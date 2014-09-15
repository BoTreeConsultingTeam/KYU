class ReportsController < ApplicationController
  before_action :set_student, only: [:student_weakness,:student_strength]
  before_action :set_standard, only: [:student_activeness, :students_questions_compare,:students_questions_compare,:students_answers_compare]
  def index
    @students = Student.all
    @standards = Standard.all
  end

  def class_activity
    @standards =Standard.all
    @questions = @standards.map{|standard| [standard.class_no, standard.questions.count]}
    @class_activity_bar_chart = GoogleChartService.render_reports_charts( @questions, :bar, "Questions asked by each Class ", :true, 'Questions', 'Class', :interactive)
  end

  def student_weakness
    @student_weakness_table = @student.questions.map{|question|question.tags.map{|tag|[tag.name,tag.taggings_count]}}.pop
    @student_weakness_chart = GoogleChartService.render_reports_charts( @student_weakness_table, :bar, "Student's tag ration", true, 'Tag', 'Count', :interactive )  
  end

  def student_strength
    @student_strength_table = @student.answers.map{|answer|answer.question.tags.map{|tag|[tag.name,tag.taggings_count]}}.pop
    @student_strength_chart = GoogleChartService.render_reports_charts( @student_strength_table, :bar, "Student's tag ration", true, 'Tag', 'Count', :interactive)  
  end

  def tags_usage
    @tags_usage_table =ActsAsTaggableOn::Tag.all.map{|tag|[tag.name,Question.tagged_with(tag).count]}
    @tags_usage_chart = GoogleChartService.render_reports_charts( @tags_usage_table, :pie, "Tags Usage", true, 'Tag', 'Count', false)  
  end

  def student_activeness
    @student_activeness_table = @standard.students.map{|student|[student.username,student.sign_in_count]}
    @student_activeness_chart = GoogleChartService.render_reports_charts( @student_activeness_table, :bar, "Student login counts", true, 'Name', 'Login Count',:interactive)  
  end

  def students_questions_compare
    @students_questions_compare_table = @standard.students.map{|student|[student.username,student.questions.count]}
    @students_questions_compare_chart = GoogleChartService.render_reports_charts(@students_questions_compare_table, :bar, "Questions asked by students", true, 'Name', 'Question Count',false)
  end

  def students_answers_compare
    @students_answers_compare_table = @standard.students.map{|student|[student.username,student.answers.count]}
    @students_answers_compare_chart = GoogleChartService.render_reports_charts(@students_answers_compare_table, :bar, "Answers given by students", true,'Name','Answers Count',:interactive)
  end

  private

    def set_student
      @student  = Student.find(params[:id])
    end

    def set_standard
      @standard = Standard.find(params[:standard_id])
    end
end

