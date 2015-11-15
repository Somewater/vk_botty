require_relative 'spec_helper'

# Alice account must have:
# - posts on wall page with some comments (from Alise and another user)
# - friends all with non empty wall page (wall page must have at least one post with comments)
# - subscription to group in which Alise is a member (with at least one post with comments)
# - subscription to group in which Alise is not a member (with at least one post with comments)


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

  xit "friend wall page" do

  end

  xit "own group wall page" do

  end

  xit "some group wall page" do

  end
end