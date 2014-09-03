class QuestionsController < ApplicationController
  
  def index
    if received_tag
      @questions = Question.tagged_with(received_tag).page params[:page]
    elsif received_time
      case received_time
      when 'week'
        @questions = Question.recent_data_week.page params[:page]
      when 'month'
        @questions = Question.recent_data_month.page params[:page]
      when 'newquestion'  
        @questions = Kaminari.paginate_array(Question.recent_data_new).page params[:page]
      when 'mostviewed'  
        @questions = Kaminari.paginate_array(Question.find_all_by_id (recent_data_view)).page params[:page]
        #impressions = Impression.select("impressionable_id, count(*) as qty").where("impressionable_type = ?", 'Question').group('impressionable_type, impressionable_id').order('qty desc').limit(3)
        #puts "******************************_#{impressions.inspect}"
        #impressions = Impression.all.recent_data_view
        #@questions = Kaminari.paginate_array(Question.joins(:impressions).where(impressions: {impressionable_id: impressions.map(&:impressionable_id)})).page params[:page]
      when 'mostvoted'  
        @questions = Kaminari.paginate_array(Question.recent_data_vote).page params[:page] 
        #votes = Vote.select("votable_id").order('votable_id desc')
        #@questions = Kaminari.paginate_array(Question.joins(:votes).where(votes: {votable_id: votes.map(&:votable_id)})).page params[:page]
      when 'unanswerd'  
        @questions = Kaminari.paginate_array(Question.recent_data_answer).page params[:page]   
      end
    else
      @questions = Question.all.page params[:page]
    end
  end

  def new
    @question = Question.new
    @question.user_id = session[:id]
  end

  def upvote
     @question = Question.find(params[:id])
     question_liked_by(@question,liked_by)
    redirect_to :back
  end

  def downvote
    @question = Question.find(params[:id])
    question_disliked_by(@question,liked_by)
    redirect_to :back
  end

  def create
    logged_in_user = current_student ? current_student : current_teacher
    @question = Question.new(question_params.merge({askable: logged_in_user}))
    if @question.save
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def show
    @question = Question.find(params[:id])
    @answers = @question.answers
    impressionist(@question, nil, { unique: [:session_hash] })
  end
  
  def edit
    @question = Question.find(params[:id])
  end

  def destroy
    @question = Question.find(params[:id])
    @question.delete
    redirect_to questions_path
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      flash[:success] = "Profile updated"
      redirect_to questions_path
    else
      render 'edit'
    end 
  end
  def alltags
    @tags = ActsAsTaggableOn::Tag.all
  end

  private
  
  def question_params
    params.require(:question).permit(:title,:content, :user_id, :tag_list)
  end

  def question_liked_by(question,user)
    question.liked_by(user)
  end

  def question_disliked_by(question,user)
    question.disliked_by(user)
  end

  def liked_by
    liked_by = current_student.present? ? current_student : current_teacher
  end

  def received_tag
      params[:tag]
  end

  def received_time
    params[:time]
  end

  def recent_data_view
    #find(:all, :order => "id desc")
    viewed = Question.all
    h = {}
    viewed.each do |q|
      h[q.impressionist_count]=q.id
    end
    
    b = Hash[h.sort_by{|k,v| k}]
    puts b.values.reverse
    b.values.reverse
    
  end
end
