class MembersController < ApplicationController
  def index
	@students = Student.all.page(params[:page]).per(5)
  end

  def show
  	@student = Student.find(params[:id])
    @questions = @student.questions
    @answers = @student.answers
  end

  private

	def received_filter
		params[:filter]
	end
end
