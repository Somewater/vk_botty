module VkBotty
  class Group < PublicationHost
    def initialize *args
      super
    end

    # @return [Array<User>]
    def members
    end

    # Posts on group wall
    # @return [Array<Post>]
    def posts
    end

    def to_s
      "Group<#{@id}>"
    end

    class GroupUser < User
    end
  end
end
