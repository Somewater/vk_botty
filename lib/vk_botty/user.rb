module VkBotty
  class User < PublicationHost

    def initialize *args
      super
    end

    # @return [Array<User>]
    def friends
      backend.friends_page(self).users
    end

    # Posts on user wall
    # @return [Array<Post>]
    def posts
      backend.wall_page(self).posts
    end

    # @return [Array<Group>]
    def groups
      raise NotImplementedError
    end

    # Private messages between current and received user
    # @param user [User]
    # @return [Array<Message>] list of messages sorted by time asc (recent first)
    def messages_from user
      backend.messages_page(user).messages
    end
  end
end
