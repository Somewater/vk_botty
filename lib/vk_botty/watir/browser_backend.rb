require 'watir-webdriver'

module VkBotty
  module Watir
    class BrowserBackend < ::VkBotty::BrowserBackend::Base

      attr_reader :logger
      attr_reader :browser
      attr_reader :captcha_recognizer
      alias :b :browser

      # @param logger
      # @param browser
      # @param captcha_recognizer [#recognize(url)]
      def initialize browser = nil, logger = nil, captcha_recognizer = nil
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
            val = b.table(id: 'myprofile_table').present?
            unless val
              logger.info "Sing in by login name #{login} unsuccessful, title #{b.title}"
              if attempts < 5
                # try to input required codes
                login_with_phone_input!(login) if b.text.index('укажите все недостающие цифры номера телефона')
                login_with_captcha! if b.text.index('Введите код с картинки')
              end
            end
            return val
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
        html ||= browser.html.sub('windows-1251', 'utf-8')
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
    end

    class Page < ::VkBotty::BrowserBackend::Page
      # parse page like private messaging area and parse messages
      # @return [Array<Message>]
      def messages
        raise NotImplementedError
      end

      # parse page like wall page (group or user) and parse posts and comments
      # @return [Array<Post>]exit
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
