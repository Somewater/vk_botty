require 'logger'

module VkBotty
  class Bot < User

    attr_reader :logged
    attr_reader :logger

    def initialize login, password, backend = nil, logger = nil
      @login = login
      @password = password
      @logged = false
      super(backend)
      @logger = logger || begin
        l = Logger.new(STDOUT)
        l.progname = "Bot<#{login}>"
        l
      end
    end

    def to_s
      "Bot<#{login}>"
    end

    def login!
      raise "Already logged" if @logged
      @logged = backend.login! @login, @password
    end

    # @param user_or_group [User, Group]
    # @param post [Post, String]
    # @return [Post]
    def post! user_or_group, post
      post = Post.create(self, post) if post.is_a? String
      page = backend.wall_page(user_or_group)
      backend.post! page, post
    end

    # @param post [Post]
    # @param comment [Comment, String]
    # @return [Comment]
    def comment! post, comment
      comment = Comment.create(self, comment) if comment.is_a? String
      page = backend.wall_page(post.wall_owner)
      backend.comment! page, post, comment
    end

    # @param user [User]
    # @param message [Message, String]
    # @return [Message]
    def message! user, message
      message = Message.create(self, message) if message.is_a? String
      page = backend.messages_page(user)
      backend.message! page, message
    end

    # @param id [Fixnum]
    # @return [User]
    def get_user id
      u = User.new(backend)
      u.id = id
      u
    end

    # @param id [Fixnum]
    # @return [Group]
    def get_group id
      g = Group.new(backend)
      g.id = id
      g
    end
  end
end