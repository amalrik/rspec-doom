# frozen_string_literal: true

require 'optparse'

module RSpecDoom
  class CLI
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      options = parse_options
      Watcher.new(options).run
      0
    end

    private

    def parse_options
      options = { directories: [] }

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: rspec-doom [options] [dir …]'

        opts.on('-c', '--cmd CMD', 'Command to run RSpec (default: bundle exec rspec)') do |cmd|
          options[:cmd] = cmd
        end

        opts.on('-d', '--debounce SECONDS', Float, 'Debounce interval in seconds (default: 0.1)') do |sec|
          options[:debounce] = sec
        end

        opts.on('--notify-file PATH', 'Write notifications to a file (useful for headless/CI)') do |path|
          options[:notifiers] = [[:file, { path: path, format: "%s|%s|%s\n" }]]
        end

        opts.on('-h', '--help', 'Show this help') do
          puts opts
          exit
        end
      end

      parser.parse!(@argv)
      options[:directories] = @argv

      options
    end
  end
end