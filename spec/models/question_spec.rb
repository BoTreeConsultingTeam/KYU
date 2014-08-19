require 'rails_helper'

RSpec.describe Question, :type => :model do

  context '#fields' do
    it { should respond_to(:title) }
    it { should respond_to(:category_id) }
    it { should respond_to(:grade_id) }
    it { should respond_to(:user_id) }
    it { should respond_to(:status) }
  end

  context '#relations' do
    it { should belong_to(:user) }
  end

end
