# frozen_string_literal: true

RSpec.describe RSpecDoom::Watcher do
  let(:watcher) { described_class.new(options) }
  let(:options) { {} }

  describe '#directories' do
    it 'defaults to app and spec' do
      expect(watcher.directories).to eq(%w[app spec])
    end

    it 'uses configured directories' do
      watcher = described_class.new(directories: %w[lib test])
      expect(watcher.directories).to eq(%w[lib test])
    end
  end

  describe '#debounce' do
    it 'defaults to 0.1' do
      expect(watcher.debounce).to eq(0.1)
    end

    it 'uses the configured value' do
      watcher = described_class.new(debounce: 0.5)
      expect(watcher.debounce).to eq(0.5)
    end
  end

  describe '#cmd' do
    it 'defaults to bundle exec rspec' do
      expect(watcher.cmd).to eq('bundle exec rspec')
    end

    it 'uses the configured command' do
      watcher = described_class.new(cmd: 'rspec')
      expect(watcher.cmd).to eq('rspec')
    end
  end

  describe '#paths_for' do
    it 'returns the spec file for a changed spec that exists' do
      allow(File).to receive(:file?).with('spec/foo_spec.rb').and_return(true)
      expect(watcher.paths_for('spec/foo_spec.rb')).to eq(['spec/foo_spec.rb'])
    end

    it 'returns no paths for a deleted spec (run whole suite)' do
      allow(File).to receive(:file?).with('spec/foo_spec.rb').and_return(false)
      expect(watcher.paths_for('spec/foo_spec.rb')).to eq([])
    end

    it 'maps a source file to its spec when the spec exists' do
      path = File.join(Dir.pwd, 'app/models/foo.rb')
      allow(File).to receive(:file?).with('spec/models/foo_spec.rb').and_return(true)
      expect(watcher.paths_for(path)).to eq(['spec/models/foo_spec.rb'])
    end

    it 'returns no paths when the mapped spec does not exist (run whole suite)' do
      allow(File).to receive(:file?).with('spec/models/foo_spec.rb').and_return(false)
      expect(watcher.paths_for('app/models/foo.rb')).to eq([])
    end

    it 'maps lib files to spec too' do
      watcher = described_class.new(directories: %w[app lib spec])
      allow(File).to receive(:file?).with('spec/doom/runner_spec.rb').and_return(true)
      expect(watcher.paths_for('lib/doom/runner.rb')).to eq(['spec/doom/runner_spec.rb'])
    end

    it 'ignores non-ruby files' do
      expect(watcher.paths_for('app/views/foo.html.erb')).to eq([])
    end
  end

  describe 'EVENTS_INTERESTED_IN' do
    it 'includes removals so deleted specs trigger a rerun' do
      expect(described_class::EVENTS_INTERESTED_IN).to include(:removed)
    end
  end
end