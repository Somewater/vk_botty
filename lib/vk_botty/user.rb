module VkBotty
  class User
    attr_accessor :id

    # @return [Array<User>]
    def friends
    end

    # Posts on user wall
    # @return [Array<Post>]
    def posts
    end

    # @return [Array<Group>]
    def groups
    end

    # Private messages between current and received user
    # @param user [User]
    # @return [Array<Message>] list of messages sorted by time asc (recent first)
    def messages_from user
    end
  end
end
