require_relative 'spec_helper'

# Alice account must joined in group


describe "Load and parse group public page" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  xit "page of group" do

  end

  xit "group users" do

  end

  xit "page of unfamiliar group" do

  end
end