module VkBotty
  class Comment < Message
    def self.create author, text
      m = Comment.new
      m.text = text
      m.author = author
      m
    end
  end
end
