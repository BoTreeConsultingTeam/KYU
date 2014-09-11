class QuestionsController < ApplicationController
  before_action :user_signed_in?
    
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
        @questions = Kaminari.paginate_array(Question.find_all_by_id(un_answered_questions)).page(params[:page]).per(10)
      when 'most_viewed'
        @questions = Question.most_viwed_question.page params[:page]
      when 'most_voted'
        @questions = Question.highest_voted.page params[:page]
      when 'newest'
        @questions = Question.newest(current_user).page params[:page]
      end
    else
      @questions = Question.all.order("created_at DESC").page params[:page]
    end
  end

  def new
    @question = Question.new
    @question.user_id = session[:id]
  end

  def create
    @question = Question.new(question_params.merge({askable: current_user}))
    if @question.save
      current_student.change_points(2)
      redirect_to questions_path
    else
      render 'new'
    end
  end

  def show
    @question = Question.find_by_id(params[:id])
    @answers = @question.answers
    @answer = Answer.new
    impressionist(@question, nil, { unique: [:session_hash] })
    @comment = Comment.new
    @comments_q = Comment.relative_comments(@question.id,@question.class)
    @comments_a = Comment.all_comments_of_answers(@answer.class)
  end

  def destroy
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to students_path,flash: { error: "No such Question found for Delete!" }
    else
      @question.destroy
      redirect_to students_path,flash: { success: "Deleted Successfuly!" }
    end
  end

  def upvote
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: "No such Question found for Vote!" }
    else
      question_liked_by(@question,liked_by)
      give_points(@question,5)
      redirect_to questions_path
    end
  end

  def downvote
    @question = Question.find_by_id(params[:id])
    if @question.nil?
      redirect_to questions_path,flash: { error: "No such Question found for Vote!" }
    else
      question_disliked_by(@question,liked_by)
      give_points(@question,-5)
      redirect_to questions_path
    end
  end
  
  def edit
    @question = Question.find(params[:id])
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
    @tags = ActsAsTaggableOn::Tag.all.page(params[:page]).per(5)

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

  def received_tag
    params[:tag]
  end

  def received_time
    params[:time]
  end
end
