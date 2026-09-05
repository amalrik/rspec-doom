# frozen_string_literal: true

RSpec.describe RSpecDoom::Runner do
  let(:options) { {} }
  let(:runner) { described_class.new(options) }

  def stub_rspec(output, exit_code)
    status = Struct.new(:exitstatus).new(exit_code)
    allow(Open3).to receive(:capture3).and_return([output, '', status])
  end

  describe '#run' do
    it 'runs the default RSpec command with format flags' do
      status = Struct.new(:exitstatus).new(0)
      expect(Open3).to receive(:capture3)
        .with('bundle exec rspec --no-color --format=progress')
        .and_return(['10 examples, 0 failures', '', status])

      runner.run
    end

    it 'appends spec paths to the command' do
      status = Struct.new(:exitstatus).new(0)
      expect(Open3).to receive(:capture3)
        .with('bundle exec rspec --no-color --format=progress spec/foo_spec.rb')
        .and_return(['5 examples, 0 failures', '', status])

      runner.run(['spec/foo_spec.rb'])
    end

    context 'when all tests pass' do
      before { stub_rspec('10 examples, 0 failures', 0) }

      it 'returns a success result' do
        result = runner.run
        expect(result[:success]).to be true
        expect(result[:failures]).to eq(0)
        expect(result[:examples]).to eq(10)
      end
    end

    context 'when some tests fail' do
      before { stub_rspec('10 examples, 3 failures', 1) }

      it 'returns a failure result' do
        result = runner.run
        expect(result[:success]).to be false
        expect(result[:failures]).to eq(3)
        expect(result[:examples]).to eq(10)
      end
    end

    context 'when tests are pending but none fail' do
      before { stub_rspec('10 examples, 0 failures, 2 pending', 0) }

      it 'returns a success result with pending examples' do
        result = runner.run
        expect(result[:success]).to be true
        expect(result[:failures]).to eq(0)
        expect(result[:examples]).to eq(10)
      end
    end

    context 'when no examples are found' do
      before { stub_rspec('No examples found.', 1) }

      it 'returns an error result, never success' do
        result = runner.run
        expect(result[:success]).to be false
        expect(result[:error]).to eq('No examples found')
      end
    end

    context 'when RSpec fails to boot' do
      before { stub_rspec("LoadError: cannot load such file -- app/foo\n", 1) }

      it 'returns an error result with a generic message' do
        result = runner.run
        expect(result[:success]).to be false
        expect(result[:error]).to eq('RSpec failed to boot or produced no summary')
      end
    end
  end
end