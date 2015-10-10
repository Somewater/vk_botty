require 'bundler/setup'
Bundler.setup

require 'vk_botty'

# download Alise and Bob account details (login:pass per line)
accounts_filepath = File.join(File.dirname(__FILE__), '..', 'test_accounts.txt')
if File.exist? accounts_filepath
  alise_login, alise_pass, bob_login, bob_pass =
      File.open(accounts_filepath) do |f|
        f.each_line.to_a.take(2).map{|line| line.split(':').take(2) }.flatten
      end
  RSpec.configure do |c|
    c.add_setting :alise_login, default: alise_login
    c.add_setting :alise_pass,  default: alise_pass
    c.add_setting :bob_login,   default: bob_login
    c.add_setting :bob_pass,    default: bob_pass
  end
else
  raise "File with test accounts info not found in path #{accounts_filepath}"
end

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
          VkBotty::Bot.new(RSpec.configuration.alise_login, RSpec.configuration.alise_pass)
        elsif name.to_s == 'bob'
          VkBotty::Bot.new(RSpec.configuration.bob_login, RSpec.configuration.bob_pass)
        end
      end
    end
  end
end

RSpec.configure do |c|
  c.include VkBotty::Test::WithAliseAndBob
end