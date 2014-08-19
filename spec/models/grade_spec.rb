require 'rails_helper'

RSpec.describe Grade, :type => :model do

  context '#fields' do
    it { should respond_to(:title) }
    it { should respond_to(:title_alias) }
  end

end
