class ReportsController < ApplicationController
  def index
    @students = Student.all.page(params[:page]).per(5)
  end

  def show
    @student = Student.find(params[:id])
    @tags = @student.owned_tags
    @tags_table = @tags.map { |obj| [obj.name, obj.taggings_count]  }
    @tags_pie_chart = GoogleChartService.render_reports_charts(data_for_chart: @tags_table,chart_type: :pie,chart_name: "Student's tag ration", required_formatter: :true,col_x: 'Tag',_col_y: 'Count')

  end
end

