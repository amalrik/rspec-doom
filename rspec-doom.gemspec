# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'rspec-doom'
  spec.version       = '0.1.0'
  spec.authors       = ['Your Name']
  spec.email         = ['your@email.com']
  spec.summary       = 'RSpec file watcher with Doom-themed notifications'
  spec.description   = 'Watches source and spec files with Cruise and runs RSpec, showing Doom guy notifications based on test results.'
  spec.homepage      = 'https://github.com/yourusername/rspec-doom'
  spec.license       = 'MIT'
  spec.files         = Dir['lib/**/*'] + Dir['bin/*']
  spec.bindir        = 'bin'
  spec.executables   = ['rspec-doom']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.2'

  spec.add_dependency 'cruise'
  spec.add_dependency 'notiffany'
  spec.add_dependency 'logger'

  spec.add_development_dependency 'rspec', '~> 3.0'
end