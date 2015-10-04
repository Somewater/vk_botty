module VkBotty
  class Comment < Message
    def self.create bot, text
      m = Comment.new
      m.text = text
      m.author = bot
      m
    end
  end
end
