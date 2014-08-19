require 'rails_helper'

RSpec.describe User, :type => :model do

  context "#fields" do
    it { should respond_to(:email) }
    it { should respond_to(:salutation) }
    it { should respond_to(:highest_qualification) }
    it { should respond_to(:first_name) }
    it { should respond_to(:middle_name) }
    it { should respond_to(:last_name) }
    it { should respond_to(:date_of_birth) }
    it { should respond_to(:active) }
    it { should respond_to(:gr_number) }
  end

  context "#relations" do
    it { should have_many(:user_roles) }
    it { should have_many(:roles).through(:user_roles) }
    it { should have_many(:questions).dependent(:destroy) }
  end


end
