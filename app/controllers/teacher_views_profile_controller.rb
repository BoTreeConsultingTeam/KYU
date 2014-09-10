class TeacherViewsProfileController < ApplicationController
  def show
    @total_downvotes_question = 0
    @total_upvotes_question = 0
    @total_upvotes_answer = 0
    @total_downvotes_answer = 0
    @teacher = Teacher.find(params[:id])
    @questions = @teacher.questions
    @answers = @teacher.answers
    @tag = @teacher.owned_tags
    @tags = @tag.map { |obj| [obj.name, obj.taggings_count]  }

    @questions.each do |question|
      @total_upvotes_question = @total_upvotes_question + question.get_upvotes.size
    end

    @questions.each do |question|
      @total_downvotes_question = @total_downvotes_question + question.get_downvotes.size
    end

    @answers.each do |answer|
      @total_upvotes_answer = @total_upvotes_answer + answer.get_upvotes.size
    end

    @answers.each do |answer|
      @total_downvotes_answer = @total_downvotes_answer + answer.get_downvotes.size
    end

  end

  private

  def received_filter
    params[:filter]
  end

end
