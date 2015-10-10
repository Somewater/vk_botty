require 'spec_helper'

describe "Load and parse wall pages" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  it "own wall page" do
  end

  it "friend wall page" do
  end

  it "own group wall page" do
  end

  it "some group wall page" do

  end
end