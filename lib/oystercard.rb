class Oystercard
  attr_reader :balance, :entry_station

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MAXIMUM_BALANCE = 90

  def initialize
    @balance = DEFAULT_BALANCE
    @entry_station = nil
  end

  def top_up(cash)
    top_up_error(cash)
    @balance += cash
  end

  def touch_in(station)
    insuff_funds_error
    @entry_station = station
  end

  def touch_out
    @entry_station = nil
    deduct(MINIMUM_BALANCE)
  end

  def in_journey?
    @entry_station != nil
  end

  private
  def deduct(cash)
    @balance -= cash
  end

  def top_up_error(cash)
    fail "Warning: top-up amount will exceed maximum balance of £#{MAXIMUM_BALANCE}" if (@balance + cash) > MAXIMUM_BALANCE
  end

  def insuff_funds_error
    raise("Not enough money on card") if @balance < MINIMUM_BALANCE
  end

end
