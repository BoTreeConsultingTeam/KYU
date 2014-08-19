require 'rails_helper'

RSpec.describe Category, :type => :model do
  context '#fields' do
    it { should respond_to(:title) }
    it { should respond_to(:title_alias) }
  end

  context '#relations' do
  end
end
