class GoogleChartService
  def self.render_reports_charts(data_for_chart, chart_type, chart_name, required_formatter, col_x, col_y, interactive)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', col_x)
    data_table.new_column('number', col_y)
    data_table.add_rows(data_for_chart)
    if required_formatter
      formatter = GoogleVisualr::ArrowFormat.new
      formatter.columns(1)
      data_table.format(formatter)
    end
    opts = { :width => Settings.google_chart.width, :height => Settings.google_chart.height, :title => chart_name, :legend => 'bottom'}
    if chart_type == :pie
      if !interactive.present?
        chart = GoogleVisualr::Interactive::PieChart.new(data_table, opts)
      else
        chart = GoogleVisualr::Image::PieChart.new(data_table, opts)
      end
    elsif chart_type == :bar
      if !interactive.present?
        chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)
      else
        chart = GoogleVisualr::Image::BarChart.new(data_table, opts)
      end
    end
    chart
  end
end