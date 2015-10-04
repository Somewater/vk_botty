require "vk_botty/version"

module VkBotty
  autoload :User, 'vk_botty/user'
  autoload :Bot, 'vk_botty/bot'
  autoload :Group, 'vk_botty/group'
  autoload :Message, 'vk_botty/message'
  autoload :Post, 'vk_botty/post'
  autoload :Comment, 'vk_botty/comment'
  autoload :PublicationHost, 'vk_botty/publication_host'

  autoload :BrowserBackend, 'vk_botty/browser_backend'

  module Watir
    autoload :BrowserBackend, 'vk_botty/watir/browser_backend'
  end

  # when requested info blocked by user
  class Blocked < RuntimeError
  end
end
