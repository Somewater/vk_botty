require 'bundler/setup'
Bundler.setup

require 'vk_botty'
require 'yaml'

module VkBotty
  module Test
    module WithAliseAndBob
      def self.included(klass)
        def klass.with_bob_and_alice!
          let :alice do
            create :alice
          end

          let :bob do
            create :bob
          end
        end
      end

      def create(name)
        if name.to_s == 'alice'
          VkBotty::Bot.new(RSpec.configuration.alise.login, RSpec.configuration.alise.password)
        elsif name.to_s == 'bob'
          VkBotty::Bot.new(RSpec.configuration.bob.login, RSpec.configuration.bob.password)
        end
      end
    end

    def self.config
      @config ||= begin
        accounts_filepath = File.join(File.dirname(__FILE__), '..', 'test_accounts.yml')
        raise "File with test accounts info not found in path #{accounts_filepath}" unless File.exist? accounts_filepath
        y = YAML.load_file(accounts_filepath)
        users = y['users'].map do |user|
          test_group = user['test_group'] && TestEntity.new(user['test_group']['id'], user['test_group']['slug'])
          test_friend = user['test_friend'] && TestEntity.new(user['test_friend']['id'], user['test_friend']['slug'])
          TestUserInfo.new(user['name'], user['login'], user['password'], test_group, test_friend)
        end
        TestConfig.new(users)
      end
    end

    TestConfig = Struct.new(:users)
    TestUserInfo = Struct.new(:name, :login, :password, :test_group, :test_friend)
    TestEntity = Struct.new(:id, :slug)
  end
end

RSpec.configure do |c|
  c.include VkBotty::Test::WithAliseAndBob
  c.add_setting :alise, default: VkBotty::Test.config.users.find{|u| u.name == 'alise' }
  c.add_setting :bob, default: VkBotty::Test.config.users.find{|u| u.name == 'bob' }
end
