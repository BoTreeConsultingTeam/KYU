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
      when 'un_answered'
        @questions = Kaminari.paginate_array(Question.find_all_by_id(un_answered_questions)).page params[:page]
      when 'most_viewed'
        @questions = Question.most_viwed_question.page params[:page]
      when 'most_voted'
        @questions = Question.highest_voted.page params[:page]
      when 'newest'
        @questions = Question.newest(current_user).page params[:page]
      end
    else
      @questions = Question.all.order("created_at desc").page params[:page]
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

  def all_questions
    questions = Question.all
  end

  def un_answered_questions
    question = {}
    all_questions.each do |q| 
      if q.answers.count == 0
        question[q.id] = q
      end
    end
    question.keys
  end
end
