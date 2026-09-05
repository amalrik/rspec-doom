# frozen_string_literal: true

RSpec.describe RSpecDoom::Notifier do
  let(:notifier) { described_class.new }

  let(:fake_notifier) do
    instance_double(Notiffany::Notifier, notify: nil, disconnect: nil)
  end

  before do
    allow(Notiffany).to receive(:connect).and_return(fake_notifier)
  end

  describe '#connect' do
    it 'connects Notiffany with the Doom title' do
      expect(Notiffany).to receive(:connect).with({ title: 'RSpec Doom' })
      notifier.connect
    end
  end

  describe '#disconnect' do
    it 'disconnects the underlying notifier' do
      notifier.connect
      expect(fake_notifier).to receive(:disconnect)
      notifier.disconnect
    end
  end

  describe '#notify' do
    context 'when all tests pass' do
      let(:result) { { success: true, examples: 10, failures: 0 } }

      it 'shows the ALL CLEAR message' do
        expect(fake_notifier).to receive(:notify).with(
          '10 tests - ALL CLEAR!',
          title: 'RSpec Doom',
          image: match(/doom1\.png$/)
        )
        notifier.connect
        notifier.notify(result)
      end
    end

    context 'when some tests fail' do
      let(:result) { { success: false, examples: 10, failures: 3 } }

      it 'shows the failure message with the doom3 image' do
        expect(fake_notifier).to receive(:notify).with(
          match(/3 failures/),
          title: 'RSpec Doom',
          image: match(/doom3\.png$/)
        )
        notifier.connect
        notifier.notify(result)
      end
    end

    context 'when the result is an error' do
      let(:result) { { success: false, examples: 0, failures: 0, error: 'No examples found' } }

      it 'does not send a notification' do
        notifier.connect
        expect(fake_notifier).not_to receive(:notify)
        notifier.notify(result)
      end
    end

    context 'with many failures' do
      let(:result) { { success: false, examples: 40, failures: 11 } }

      it 'uses the doom5 image' do
        expect(fake_notifier).to receive(:notify).with(
          anything,
          title: 'RSpec Doom',
          image: match(/doom5\.png$/)
        )
        notifier.connect
        notifier.notify(result)
      end
    end
  end

  describe '#determine_level' do
    it 'returns 1 for 0 failures' do
      expect(notifier.send(:determine_level, 0)).to eq(1)
    end

    it 'returns 2 for 1-2 failures' do
      expect(notifier.send(:determine_level, 1)).to eq(2)
      expect(notifier.send(:determine_level, 2)).to eq(2)
    end

    it 'returns 3 for 3-5 failures' do
      expect(notifier.send(:determine_level, 3)).to eq(3)
      expect(notifier.send(:determine_level, 4)).to eq(3)
      expect(notifier.send(:determine_level, 5)).to eq(3)
    end

    it 'returns 4 for 6-10 failures' do
      expect(notifier.send(:determine_level, 6)).to eq(4)
      expect(notifier.send(:determine_level, 10)).to eq(4)
    end

    it 'returns 5 for 11+ failures' do
      expect(notifier.send(:determine_level, 11)).to eq(5)
      expect(notifier.send(:determine_level, 100)).to eq(5)
    end
  end

  describe '#image_for' do
    it 'returns a path to doom1.png for level 1' do
      expect(notifier.send(:image_for, 1)).to match(/doom1\.png$/)
    end

    it 'returns a path to doom5.png for level 5' do
      expect(notifier.send(:image_for, 5)).to match(/doom5\.png$/)
    end
  end
end