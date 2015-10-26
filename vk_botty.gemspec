# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vk_botty/version'

Gem::Specification.new do |spec|
  spec.name          = "vk_botty"
  spec.version       = VkBotty::VERSION
  spec.authors       = ["Pavel Naydenov"]
  spec.email         = ["naydenov.p.v@gmail.com"]

  spec.summary       = 'Vkontakte site adapter on Ruby'
  spec.description   = <<-EOF
VkBotty is a tool to write VKontakte bots and automate social actions.
Library emulates user interaction directly through vk site using headless browser. It's not a Vkontakte API adapter.
EOF
  spec.homepage      = "https://github.com/Somewater/vk_botty"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "watir", "~> 5.0.0"

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
