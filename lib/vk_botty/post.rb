module VkBotty
  class Post < Message

    # @return [User, Group]
    attr_accessor :wall_owner

    # @return [Array<Comment>]
    def comments
    end

    def self.create author, text
      m = Post.new
      m.text = text
      m.author = author
      m
    end
  end
end
