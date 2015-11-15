require_relative 'spec_helper'

# Alice account must joined in group


describe "Commenting" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  xit "comment post on own page" do

  end

  xit "comment post on friend's page" do

  end

  xit "comment post on group page" do

  end
end