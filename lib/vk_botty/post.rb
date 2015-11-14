module VkBotty
  class Post < Message

    # @return [User, Group]
    attr_accessor :wall_owner

    # @return [Array<Comment>]
    def comments
      raise NotImplementedError
    end

    def to_s
      "Post<author=#{author}, text=\"#{text[0..20]}\"" +
        comments.map{|c| "\n\t" + c.to_s }.join('') +
        ">"
    end
  end
end
