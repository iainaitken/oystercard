require 'oystercard'

describe Oystercard do
  let(:entry_station) { double(:station) }
  let(:exit_station) { double(:station) }

  it 'oystercard has a balance of 0' do
    expect(subject.balance).to eq Oystercard::DEFAULT_BALANCE
  end

  describe '#top_up' do
    it 'Card has top-up facility' do
      expect(subject).to respond_to(:top_up).with(1).argument
    end
    it 'User can add money to the card' do
      expect{subject.top_up(10)}.to change{subject.balance}.by 10
    end
    it 'User cannot top up more than card maximum' do
      max_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(max_balance)
      expect{subject.top_up(1)}.to raise_error("Warning: top-up amount will exceed maximum balance of £#{max_balance}")
    end
  end

  describe '#touch_in' do
    it 'user can use card to touch in' do
      expect(subject).to respond_to(:touch_in)
    end
    it 'user cannot touch in if they are poor' do
      expect { subject.touch_in(entry_station) }.to raise_error("Not enough money on card")
    end
    context 'when user has touched in' do
      before(:each) do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
      end
      it 'card is in use' do
        subject.touch_in(entry_station)
        expect(subject.in_journey?).to be true
      end
      it 'has stored touch_in station' do
        expect { subject.touch_in(entry_station) }.to change { subject.entry_station }.to entry_station
      end
    end
  end

  describe '#touch-out' do
    it 'user can use card to touch out' do
      expect(subject).to respond_to(:touch_out)
    end
    it 'user is charged on touch out' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(entry_station)
      expect{subject.touch_out(exit_station)}.to change{subject.balance}.by -Oystercard::MINIMUM_BALANCE
    end

    context 'when user has touched out' do
      before(:each) do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in(entry_station)
      end
      it 'card is not in use' do
        subject.touch_out(exit_station)
        expect(subject.in_journey?).to be false
      end
      it 'changes entry_station value to nil' do
        expect { subject.touch_out(exit_station) }.to change { subject.entry_station }.to nil
      end
      it 'has stored touch_out station' do
        expect { subject.touch_out(exit_station) }.to change { subject.exit_station }
      end
    end
  end

  describe '#in_journey?' do
    it 'user can check whether card is in use' do
      expect(subject).to respond_to(:in_journey?)
    end
  end
end
