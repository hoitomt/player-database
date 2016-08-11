require 'test_helper'

describe "User" do
  let(:user){ create :user }

  it "creates a user" do
    user.wont_be_nil
  end
end
