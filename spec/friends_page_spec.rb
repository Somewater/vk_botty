require_relative 'spec_helper'

# Alice account must have a friend Bob


describe "Load and parse friends page" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  xit "can detect friend list" do

  end

  xit "can detect another user friend list" do

  end
end