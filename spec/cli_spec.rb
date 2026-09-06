# frozen_string_literal: true

RSpec.describe RSpecDoom::CLI do
  let(:fake_watcher) { double(run: nil) }

  describe '#run' do
    it 'passes positional directories as watch dirs' do
      allow(RSpecDoom::Watcher).to receive(:new).with({ directories: %w[app spec] })
                                     .and_return(fake_watcher)
      expect(fake_watcher).to receive(:run)

      cli = described_class.new(%w[app spec])
      expect(cli.run).to eq(0)
    end

    it 'parses a custom command and debounce' do
      allow(RSpecDoom::Watcher).to receive(:new)
        .with({ cmd: 'rspec', debounce: 0.5, directories: [] })
        .and_return(fake_watcher)
      expect(fake_watcher).to receive(:run)

      cli = described_class.new(%w[--cmd rspec --debounce 0.5])
      expect(cli.run).to eq(0)
    end

    it 'parses a notify file' do
      allow(RSpecDoom::Watcher).to receive(:new)
        .with({
          notifiers: [[:file, { path: '/tmp/notify.txt', format: "%s|%s|%s\n" }]],
          directories: []
        })
        .and_return(fake_watcher)
      expect(fake_watcher).to receive(:run)

      cli = described_class.new(%w[--notify-file /tmp/notify.txt])
      expect(cli.run).to eq(0)
    end
  end

  describe '.start' do
    it 'delegates to the CLI run and returns 0' do
      allow(RSpecDoom::Watcher).to receive(:new).with({ directories: [] }).and_return(fake_watcher)
      expect(fake_watcher).to receive(:run)

      expect(described_class.start([])).to eq(0)
    end
  end
end