class GoogleChartService
  def self.render_reports_charts(opts = {})
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', opts[:col_x])
    data_table.new_column('number', opts[:col_y])
    data_table.add_rows(opts[:data_for_chart])
    option = { width: 400, height: 240, title: opts[:chart_name] }
    if opts[:required_formatter]
      formatter = GoogleVisualr::ArrowFormat.new
      formatter.columns(1)
      data_table.format(formatter)
    end
    case opts[:chart_type]
    when :pie
      chart = GoogleVisualr::Interactive::PieChart.new(data_table, option)

    when :bar
      chart = GoogleVisualr::Interactive::BarChart.new(data_table, option)
    end
  end
end