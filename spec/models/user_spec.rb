# require 'rails_helper'
require '../spec_helper'

describe User do

  let(:user) { User.new }
  it { should respond_to(:gr_number) }
  it { should respond_to(:first_name) }
  it { should respond_to(:middle_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:date_of_birth) }
  it { should respond_to(:email) }
  it { should respond_to(:password) }

  context "#gr_number" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:gr_number]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:gr_number]).to include("is required")
    end
  end

  context "#first_name" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:first_name]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:first_name]).to include("is required")
    end
  end

  context "#middle_name" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:middle_name]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:middle_name]).to include("is required")
    end
  end

  context "#last_name" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:last_name]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:last_name]).to include("is required")
    end
  end

  context "#date_of_birth" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:date_of_birth]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:date_of_birth]).to include("is required")
    end
  end

  context "#email" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:email]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:email]).to include("is required")
    end
  end

  context "#password" do
    let!(:errors) { user.save; user.errors }

    it "can't be blank" do
      expect(errors[:password]).not_to be_empty
    end

    it "when blank shows user-friendly message" do
      expect(errors[:password]).to include("is required")
    end
  end
end
