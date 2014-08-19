require 'rails_helper'

RSpec.describe Tagging, :type => :model do
  context '#fields' do
    it { should respond_to(:tag) }
    it { should respond_to(:taggable_id) }
    it { should respond_to(:taggable_type) }
  end

  context '#relations' do
    it { should belong_to(:tag) }
    it { should belong_to(:taggable) }
  end
end
