require_relative 'spec_helper'

# Alice account must joined in group and must have a friend


describe "Posting" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  xit "post in group" do

  end

  xit "post on own wall page" do

  end

  xit "post on friend wall page" do

  end
end