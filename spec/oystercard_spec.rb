require 'oystercard'

describe Oystercard do

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
      expect { subject.touch_in }.to raise_error("Not enough money on card")
    end
    context 'when user has touched in' do
      it 'card is in use' do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in
        expect(subject.in_journey?).to be true
      end
    end
  end

  describe '#touch-out' do
    it 'user can use card to touch out' do
      expect(subject).to respond_to(:touch_out)
    end
    it 'user is charged on touch out' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in
      expect{subject.touch_out}.to change{subject.balance}.by -Oystercard::MINIMUM_BALANCE
    end

    context 'when user has touched out' do
      it 'card is not in use' do
        subject.top_up(Oystercard::MINIMUM_BALANCE)
        subject.touch_in
        subject.touch_out
        expect(subject.in_journey?).to be false
      end
    end
  end

  describe '#in_journey?' do
    it 'user can check whether card is in use' do
      expect(subject).to respond_to(:in_journey?)
    end
  end
end
