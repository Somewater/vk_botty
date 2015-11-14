require_relative 'spec_helper'

# Alice account must have posts on wall page with some comments (from Alise and another user)

describe "Load and parse wall pages" do

  def alice
    @alice ||= create(:alice)
  end

  before :all do
    alice.login!
  end

  it "own wall page" do
    posts = alice.posts
    expect(posts).not_to be_empty
    post = posts.first
    expect(post).to be_a(VkBotty::Post)
    expect(post.text).not_to be_empty
    expect(
      posts.any?{|p| !p.comments.empty? && p.comments.first.is_a?(VkBotty::Comment) }
    ).to be_truthy
  end

  it "friend wall page" do
  end

  it "own group wall page" do
  end

  it "some group wall page" do

  end
end