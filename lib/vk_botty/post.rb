module VkBotty
  class Post < Message

    # @return [User, Group]
    attr_accessor :wall_owner

    # @return [Array<Comment>]
    def comments
    end

    def self.create bot, text
      m = Post.new
      m.text = text
      m.author = bot
      m
    end
  end
end
