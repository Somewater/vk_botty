module VkBotty
  class Post < Message

    # @return [User, Group]
    attr_accessor :wall_owner

    # @return [Array<Comment>]
    def comments
      raise NotImplementedError
    end
  end
end
