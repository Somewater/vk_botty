require 'spec_helper'

describe "Login" do
  with_bob_and_alice!

  it "Alice should login" do
    expect(
      alice.login!
    ).to be_truthy
  end

  it "Alice should not login with wrong password" do
    expect(
      VkBotty::Bot.new(RSpec.configuration.alise_login, '12345').login!
    ).to be_falsey
  end

  it "Bob should login" do
    expect(
      bob.login!
    ).to be_truthy
  end

  it "Should not allow login twice" do
    alice.login!

    expect {
      alice.login!
    }.to raise_error("Already logged")
  end
end