module VkBotty
  class Group
    attr_accessor :id

    # @return [Array<User>]
    def members
    end

    # Posts on group wall
    # @return [Array<Post>]
    def posts
    end


    class GroupUser < User
    end
  end
end
