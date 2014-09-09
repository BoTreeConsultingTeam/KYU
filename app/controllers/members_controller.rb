class MembersController < ApplicationController
  
  def index
	@students = Student.all.page(params[:page]).per(5)
  end

  def show
    @total_downvotes_question = 0
    @total_upvotes_question = 0
    @total_upvotes_answer = 0
    @total_downvotes_answer = 0
  	@student = Student.find(params[:id])
    @questions = @student.questions
    @answers = @student.answers
    @tag = @student.owned_tags
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
