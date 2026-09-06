# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = 'rspec-doom'
  spec.version       = '0.1.0'
  spec.authors       = ['Amalrik Maia']
  spec.email         = ['amalrik.maia@gmail.com']
  spec.summary       = 'RSpec file watcher with Doom-themed notifications'
  spec.description   = 'Watches source and spec files with Cruise and runs RSpec, showing Doom guy notifications based on test results.'
  spec.homepage      = 'https://github.com/amalrik/rspec-doom'
  spec.license       = 'MIT'
  spec.files         = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec|\.github|\.ruby-lsp)/}) }
  end
  spec.bindir        = 'bin'
  spec.executables   = ['rspec-doom']
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 3.2'

  spec.metadata = {
    'homepage_uri' => spec.homepage,
    'source_code_uri' => spec.homepage,
    'rubygems_mfa_required' => 'true'
  }

  spec.add_dependency 'cruise'
  spec.add_dependency 'notiffany'
  spec.add_dependency 'logger'

  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end