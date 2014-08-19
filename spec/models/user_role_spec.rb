require 'rails_helper'

RSpec.describe UserRole, :type => :model do

  context '#fields' do
    it { should respond_to(:user_id) }
    it { should respond_to(:role_id) }
  end

  context 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:role) }
  end

end
