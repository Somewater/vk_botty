require 'logger'

module VkBotty
  class Bot < User

    attr_accessor :logged
    attr_accessor :logger

    def initialize login, password, backend = nil, logger = nil
      @login = login
      @password = password
      @logged = false
      @backend = backend || Watir::BrowserBackend.new
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
    end

    def post! user_or_group, post
    end

    def comment! post, comment
    end

    def message! user, message
    end

    def get_user id
    end

    def get_group id
    end
  end
end