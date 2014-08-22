module QuestionsHelper
  private
    def received_tag
      params[:tag]
    end

    def received_time
      params[:time]
    end

    def link_for(link_text,time)
      link_to "#{link_text}", questions_path(:time => "#{time}")
    end
end
