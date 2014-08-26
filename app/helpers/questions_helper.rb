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
    
  def get_user_name(id)
    Student.find(Question.find(id)).first_name
  end

  def set_link(title,time)
  	link_to title, questions_path(:time => 'week')
  end

end
