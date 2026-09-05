# frozen_string_literal: true

require 'cruise'

module RSpecDoom
  class Watcher
    EVENTS_INTERESTED_IN = %i[modified created renamed changed].freeze
    DEFAULT_DEBOUNCE = 0.1

    attr_reader :options

    def initialize(options = {})
      @options = options
    end

    # Watches the configured directories and runs RSpec whenever a spec or a
    # source file changes. Blocks until interrupted.
    def run
      notifier.connect
      watch_loop
    rescue Interrupt
      nil
    ensure
      notifier.disconnect
    end

    # The directories to watch, defaulting to 'app' and 'spec'.
    def directories
      dirs = options[:directories]
      dirs.nil? || dirs.empty? ? %w[app spec] : dirs
    end

    def debounce
      options[:debounce] || DEFAULT_DEBOUNCE
    end

    def cmd
      options[:cmd] || 'bundle exec rspec'
    end

    # The list of spec files to run for a changed path.
    #
    #   spec/foo_spec.rb            -> ['spec/foo_spec.rb']
    #   app/models/foo.rb (exists)  -> ['spec/models/foo_spec.rb'] (if exists)
    #   app/models/foo.rb (no spec) -> [] (run whole suite)
    def paths_for(event_path)
      relative = relative_path(event_path)

      if spec_file?(relative)
        [relative]
      elsif source_file?(relative)
        spec_for_source(relative)
      else
        []
      end
    end

    private

    def watch_loop
      Cruise.watch(
        *directories,
        debounce: debounce,
        only: EVENTS_INTERESTED_IN
      ) do |event|
        run_rspec(paths_for(event.path))
      end
    end

    def run_rspec(paths)
      notifier.notify(runner.run(paths))
    end

    def notifier
      @notifier ||= Notifier.new(options)
    end

    def runner
      @runner ||= Runner.new(options)
    end

    def relative_path(event_path)
      return event_path unless event_path.start_with?(Dir.pwd)

      event_path.sub("#{Dir.pwd}/", '')
    end

    def spec_file?(relative_path)
      relative_path.start_with?('spec/') && relative_path.end_with?('_spec.rb')
    end

    def source_file?(relative_path)
      directories.any? { |dir| relative_path.start_with?("#{dir}/") } &&
        relative_path.end_with?('.rb')
    end

    def spec_for_source(relative_path)
      candidate = relative_path.sub(%r{\A(app|lib)/}, 'spec/')
                              .sub(/\.rb\z/, '_spec.rb')
      File.file?(candidate) ? [candidate] : []
    end
  end
end