class QuestionsController < ApplicationController
  before_action :user_signed_in?
  before_filter :tag_list, only: [:new, :edit]
  before_filter :question_find_by_id, only: [:show, :destroy, :edit]

  def index
    params[:active_tab_menu] = 'all'
    if received_tag
      @tag = ActsAsTaggableOn::Tag.find_by_name(received_tag)
      @questions = Question.tagged_with(received_tag).enabled.page params[:page]
    elsif received_active_tab
      active_tab(received_active_tab)
    else
      @question = Question.all.page params[:page] 
    end
  end
  
  def disabled_questions
    @questions = Question.find_all_by_enabled(false).sort.reverse
  end

  def new
    @standards = Standard.all
    if !(current_administrator)
      @question = Question.new
      @question.user_id = session[:id]
    else
      flash[:error] = t('answers.messages.unauthorized')
      redirect_to members_path(active_tab: 'Students')
    end
  end

  def create
    if !current_administrator
      @question = Question.new(question_params.merge({askable: current_user}).except!(:tag_list))
      current_user.tag( @question, :with => question_params[:tag_list], :on => :tags )
      if @question.save
        if current_student
          current_student.change_points(Point.action_score(1))
        end
        redirect_to questions_path(active_tab: 'all')
      else
        flash[:error] = t('answers.messages.unauthorized')
        redirect_to questions_path
      end
    end
  end

  def show
    if !(@question.nil?)
      @answers = @question.answers.page params[:page]
      @answer = Answer.new
      impressionist(@question, nil, { unique: [:session_hash] })
      @comment = Comment.new
      @question_comments = Comment.relative_comments(@question.id,@question.class).page(params[:page]).per(params[:per])
      @answer_comments = Comment.all_comments_of_answers(@answer.class)
    else
      redirect_to questions_path(active_tab: 'all'),flash: { error: t('flash_message.error.question.show') }
    end
  end

  def destroy 
    title = @question.title
    if question_find_by_id.nil?
      flash[:error] = t('flash_message.error.question.destroy')
    else
      @question.destroy
      flash[:notice] = "#{title} "+ t('flash_message.success.question.destroy')
    end
    if current_administrator.present?
      redirect_to disabled_questions_path
    else
      redirect_to students_path
    end
  end

  def vote
    @rule = set_rule 1
    if check_permission current_user,@rule
      @question = question_find_by_id
      if question_find_by_id.nil?
        redirect_to questions_path,flash: { error: t('flash_message.error.question.vote') }
      else
        if 'up' == params[:type] 
          if !@question.get_likes.map{|vote| vote.voter}.include?current_user
            question_liked_by(@question,liked_by)
            give_points(@question, Point.action_score(3))
          end
        else
          if !@question.get_dislikes.map{|vote| vote.voter}.include?current_user
            question_disliked_by(@question,liked_by)
            give_points(@question, Point.action_score(5))
          end
        end
        respond_to do |format|
          format.js
        end
      end
    else
      flash[:error] = t('answers.messages.unauthorized')
      redirect_to questions_path
    end

  end
  
  def edit
    @standards = Standard.all
    @standards = Standard.all
    if question_find_by_id.nil?
      redirect_to questions_path(active_tab: 'all'),flash: { error: t('flash_message.error.question.edit') }
    end
  end
  
  def update
    if !(@question.present?) 
      @question.update(question_params.merge({askable: current_user}).except!(:tag_list))
      current_user.tag( @question, :with => question_params[:tag_list], :on => :tags )
      flash[:notice] = t('flash_message.success.question.update')
      redirect_to question_path(params[:id])
    else
      redirect_to questions_path(active_tab: 'all'),flash: { error: t('flash_message.error.question.update') }
    end 
  end

  def enable 
    @question = Question.find_by_id(params[:id])
    @question.update_attributes(enabled: true)
    give_points(@question, Point.action_score(7))

    redirect_to disabled_questions_path
  end

  def disable
    @question = question_find_by_id
    if @question.nil?
      flash[:error] = t('flash_message.error.question.disable')
    else
      @question.enabled = false
      if @question.save
        give_points(@question, Point.action_score(8))
      end
    end
    redirect_to questions_path(active_tab: 'all')
  end

  def abuse_report
    @rule = set_rule 5
    if check_permission current_user,@rule
      @question = question_find_by_id
      if @question.nil?
        flash[:error] =  t('flash_message.error.question.report_abuse') 
      else
        Question.send_question_answer_abuse_report(current_user,@question)
        flash[:notice] = t('flash_message.success.question.report_abuse')
      end
      redirect_to questions_path(active_tab: 'all')
    else
      flash[:error] =  t('answers.messages.unauthorized')
      redirect_to questions_path
    end
  end

  private
  
  def active_tab(active_tab_params)
    case active_tab_params
      when 'all'
        @questions = all_questions.page params[:page]  
      when 'week'
        @questions = Question.recent_data_week.enabled.page params[:page]
      when 'month'
        @questions = Question.recent_data_month.enabled.page params[:page]
      when 'un_answered'
        @questions = Kaminari.paginate_array(Question.enabled.find_all_by_id(un_answered_questions).reverse).page params[:page]
      when 'most_viewed'
        @questions = Question.most_viwed_question.enabled.page params[:page]
      when 'most_voted'
        @questions = Question.highest_voted.enabled.page params[:page]
      when 'newest'
        @questions = Question.newest(current_user).enabled.page params[:page]
      end
  end

  def question_params
    params.require(:question).permit(:standard_id, :title, :content, :user_id, :tag_list =>[])
  end

  def question_liked_by(question,user)
    question.liked_by(user)
  end

  def question_disliked_by(question,user)
    question.disliked_by(user)
  end

  def received_tag
    params[:tag]
  end

  def received_active_tab
    params[:active_tab]
  end

  def question_find_by_id
    @question = Question.find_by_id(params[:id])
  end

  def all_questions
    Question.where("enabled = ?",true).order("created_at desc")
  end

  def un_answered_questions
    answer_counts = {}
    all_questions.each do |question| 
      if question.answers.count == 0
        answer_counts[question.id] = question
      end
    end
    answer_counts.keys
  end

  def tag_list
    @tags = ActsAsTaggableOn::Tag.all
  end
  
  def received_keyword
    params[:keyword].gsub(/\s+/, "")
  end
end
