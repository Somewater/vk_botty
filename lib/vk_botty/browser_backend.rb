module VkBotty
  module BrowserBackend
    class Base
      # @return [Boolean] true if successfully logged in
      def login! login, password
        raise NotImplementedError
      end

      # url like https://vk.com/id{user.id} or https://vk.com/club{group.id}
      # @return [Page#posts]
      def wall_page user_or_group
        raise NotImplementedError
      end

      # url like https://vk.com/friends?id={user.id}&section=all or https://vk.com/friends (for current user)
      # @return [Page#users]
      def friends_page user
        raise NotImplementedError
      end

      # url like https://vk.com/im?sel={user.id}
      # @return [Page#messages]
      def messages_page user
        raise NotImplementedError
      end

      # @see Page#post!
      def post! page, text
        raise NotImplementedError
      end

      # @see Page#message!
      def message! page, text
        raise NotImplementedError
      end

      # @see Page#comment!
      def comment! page, post, text
        raise NotImplementedError
      end
    end

    class Page
      # @return [BrowserBackend]
      attr_accessor :backend

      # @return [String]
      attr_accessor :title

      # parse page like private messaging area and parse messages
      # @return [Array<Message>]
      def messages
        raise NotImplementedError
      end

      # parse page like wall page (group or user) and parse posts and comments
      # @return [Array<Post>]
      def posts
        raise NotImplementedError
      end

      # parse page like list of friends and parse friends
      # @return [Array<User>]
      def users
        raise NotImplementedError
      end
    end
  end
end
