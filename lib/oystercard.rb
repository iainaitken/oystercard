class Oystercard
  attr_reader :balance, :in_use, :entry_station
  alias :in_journey? :in_use
  undef :in_use

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MAXIMUM_BALANCE = 90

  def initialize
    @balance = DEFAULT_BALANCE
    @in_use = false
    @entry_station = nil
  end

  def top_up(cash)
    fail "Warning: top-up amount will exceed maximum balance of £#{MAXIMUM_BALANCE}" if (@balance + cash) > MAXIMUM_BALANCE
    @balance += cash
  end

  def touch_in(station)
    raise("Not enough money on card") if @balance < MINIMUM_BALANCE
    @entry_station = station
    @in_use = true
  end

  def touch_out
    @in_use = false
    @entry_station = nil
    deduct(MINIMUM_BALANCE)
  end

  private
  def deduct(cash)
    @balance -= cash
  end

end
