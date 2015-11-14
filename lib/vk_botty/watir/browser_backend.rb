require 'watir-webdriver'

module VkBotty
  module Watir
    class BrowserBackend < ::VkBotty::BrowserBackend::Base

      attr_reader :logger
      attr_reader :browser
      attr_reader :captcha_recognizer
      attr_reader :bot
      alias :b :browser

      # variables
      attr_reader :uid

      # @param logger
      # @param browser
      # @param captcha_recognizer [#recognize(url)]
      def initialize bot, browser = nil, logger = nil, captcha_recognizer = nil
        @bot = bot
        @browser = browser || create_browser
        @logger = logger || begin
          l = Logger.new(STDOUT)
          l.progname = "Watir::BrowserBackend"
          l.level = Logger::DEBUG
          l
        end
        @captcha_recognizer = captcha_recognizer
      end

      def login! login, password
        b.goto "https://vk.com"
        logger.debug "Go to vk.com, title='#{b.title}'"

        b.text_field(:name, 'email').set(login)
        b.text_field(:name, 'pass').set(password)
        if b.button(:id, 'quick_login_button').present?
          b.button(:id, 'quick_login_button').click
        else
          b.forms.first.submit
        end

        attempts = 0

        while attempts < 10
          catch :check_login do
            attempts += 1
            logger.debug "Login to vk.com, title='#{b.title}', attempt #{attempts}"
            success = b.table(id: 'myprofile_table').present?
            unless success
              logger.info "Sing in by login name #{login} unsuccessful, title #{b.title}"
              if attempts < 5
                # try to input required codes
                login_with_phone_input!(login) if b.text.index('укажите все недостающие цифры номера телефона')
                login_with_captcha! if b.text.index('Введите код с картинки')
              end
            end
            after_login if success
            return success
          end
        end
      end

      # @return [Page#posts]
      def wall_page user_or_group
        name = if user_or_group.is_a?(User)
                 "id#{user_or_group.id}"
               else
                 "club#{user_or_group.id}"
               end
        b.goto "https://vk.com/#{name}"
        Page.new(b, bot)
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

      def create_browser
        ::Watir::Browser.new :phantomjs
      end

      def debug_print html = nil
        self.class.debug_print(html || browser.html)#.sub('windows-1251', 'utf-8'))
      end

      def self.debug_print html
        filename = "debug_print_#{rand.to_s[2..-1]}"
        File.open("#{filename}.html", 'w'){|f| f.write html}
        `lynx -dump #{filename}.html > #{filename}.txt`
        puts File.open("#{filename}.txt").read
        File.unlink "#{filename}.html"
        File.unlink "#{filename}.txt"
      rescue Errno::ENOENT
        logger.warn "Lynx not found, install it with 'sudo apt-get install lynx'"
      end

      # protected

      def login_with_phone_input! login
        logger.debug "Login with phone number input"
        b.text_field(id: 'code').set(login[1..-3])
        b.button(id: 'validate_btn').click
        throw :check_login
      end

      def login_with_captcha!
        if captcha_recognizer
          logger.debug "Login with captcha"
          url = b.div(class: 'captcha').img.src
          value = captcha_recognizer.recognize(url)
          logger.debug "Captcha from #{url} recognized as #{value}"
          b.div(class: 'captcha').text_field(placeholder: 'Введите код сюда').set(value)
          b.button(text: 'Отправить').click
          throw :check_login
        else
          logger.debug "Captcha requested but recognizer not provided"
          throw :check_login
        end
      end

      def after_login
        @uid = b.execute_script("return window.vk.id").to_i
      end
    end

    class Page < ::VkBotty::BrowserBackend::Page
      def initialize(browser, bot)
        super(browser, bot)
      end

      # parse page like private messaging area and parse messages
      # @return [Array<Message>]
      def messages
        raise NotImplementedError
      end

      # parse page like wall page (group or user) and parse posts and comments
      # @return [Array<Post>]exit
      def posts

        b.div(id: 'page_wall_posts').divs(class: 'post_table').map do |div|
          author_id = div.a(class: 'author').attribute_value('data-from-id').to_i
          text = if div.div(class: 'wall_post_text').present?
                   div.div(class: 'wall_post_text').inner_html
                 end
          comments = []
          Post.new(bot.get_user(author_id), text, comments)
        end
      end

      # parse page like list of friends and parse friends
      # @return [Array<User>]
      def users
        raise NotImplementedError
      end
    end

    class Post < ::VkBotty::Post
      def initialize author, text, comments
        self.text = text
        self.author = author
        @comments = comments
      end

      def comments
        @comments
      end
    end
  end
end
