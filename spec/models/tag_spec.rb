require 'rails_helper'

RSpec.describe Tag, :type => :model do
  context '#fields' do
    it { should respond_to(:title) }
    it { should respond_to(:title_alias) }
  end

  context '#relations' do
    #it { should have_many(:questions) }
  end
end
