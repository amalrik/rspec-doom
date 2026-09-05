# frozen_string_literal: true

require 'open3'
require 'shellwords'

module RSpecDoom
  class Runner
    RSPEC_ARGS = %w[--no-color --format=progress].freeze

    attr_reader :options

    def initialize(options = {})
      @options = options || {}
    end

    def run(paths = [])
      cmd = [options[:cmd] || 'bundle exec rspec', *RSPEC_ARGS].join(' ')
      cmd += " #{paths.flatten.compact.map { |p| Shellwords.escape(p.to_s) }.join(' ')}" if paths.any?

      stdout, stderr, status = Open3.capture3(cmd)

      parse_result([stdout, stderr].join("\n"), status.exitstatus)
    end

    private

    def parse_result(output, exit_code)
      failures = parse_failures(output)
      examples = parse_examples(output)

      if summary_missing?(output, examples)
        {
          success: false,
          examples: examples,
          failures: failures,
          output: output,
          error: no_summary_reason(output)
        }
      else
        {
          success: exit_code.zero? && failures.zero?,
          examples: examples,
          failures: failures,
          output: output
        }
      end
    end

    def parse_failures(output)
      output.scan(/(\d+) failures?/).first&.[](0)&.to_i || 0
    end

    def parse_examples(output)
      output.scan(/(\d+) examples?/).first&.[](0)&.to_i || 0
    end

    def summary_missing?(output, examples)
      examples.zero? && !output.include?('0 examples')
    end

    def no_summary_reason(output)
      if output.include?('No examples found.')
        'No examples found'
      else
        'RSpec failed to boot or produced no summary'
      end
    end
  end
end