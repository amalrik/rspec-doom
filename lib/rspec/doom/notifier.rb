# frozen_string_literal: true

require 'notiffany'

module RSpecDoom
  class Notifier
    MESSAGES = {
      1 => 'Minor casualties...',
      2 => 'Taking damage!',
      3 => 'It\'ll be fine... probably',
      4 => 'REQUIRED: MORE DAKKA!',
      5 => 'IMPS EVERYWHERE!'
    }.freeze

    def initialize(options = {})
      @options = options
      @notifier = nil
    end

    def connect
      @notifier = Notiffany.connect({ title: 'RSpec Doom' }.merge(@options))
    end

    def disconnect
      @notifier&.disconnect
    end

    def notify(result)
      return if result[:error]

      level = determine_level(result[:failures])
      image_path = image_for(level)

      message = build_message(result, level)

      notifier.notify(
        message,
        title: 'RSpec Doom',
        image: image_path
      )
    end

    private

    attr_reader :notifier

    def determine_level(failures)
      case failures
      when 0 then 1
      when 1..2 then 2
      when 3..5 then 3
      when 6..10 then 4
      else 5
      end
    end

    def images_path
      File.join(__dir__, 'assets', 'images')
    end

    def image_for(level)
      path = File.join(images_path, "doom#{level}.png")
      return path if File.exist?(path)

      nil
    end

    def build_message(result, level)
      examples = result[:examples]
      failures = result[:failures]

      if result[:success]
        "#{examples} tests - ALL CLEAR!"
      else
        "#{MESSAGES[level]} (#{failures} failures)"
      end
    end
  end
end