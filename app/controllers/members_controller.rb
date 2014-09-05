class MembersController < ApplicationController
  
  def index
    @students = Student.all.page(params[:page]).per(5)
  end

  def show
    @student = Student.find(params[:id])
    @arr = @student.owned_tags
    @arr.map { |obj| [obj.name, obj.taggings_count]  }
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Tag' )
    data_table.new_column('number', 'Count')
    data_table.add_rows(@arr.map { |obj| [obj.name, obj.taggings_count]  })
    option = { width: 400, height: 240, title: "Student's tag ratio" }
    @pie = GoogleVisualr::Interactive::PieChart.new(data_table, option)
  end

end
