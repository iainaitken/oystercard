class Oystercard
  attr_reader :balance, :current_journey, :journeys

  DEFAULT_BALANCE = 0
  MINIMUM_BALANCE = 1
  MAXIMUM_BALANCE = 90

  def initialize
    @balance = DEFAULT_BALANCE
    @current_journey = {entry_station: nil, exit_station: nil }
    @journeys = []
  end

  def top_up(cash)
    top_up_error(cash)
    @balance += cash
  end

  def touch_in(station)
    insuff_funds_error
    @current_journey[:entry_station] = station
  end

  def touch_out(station)
    @entry_station = nil
    @current_journey[:exit_station] = station
    @journeys << @current_journey
    @current_journey[:entry_station] = nil
    @current_journey[:exit_station] = nil
    deduct(MINIMUM_BALANCE)
  end

  def in_journey?
    @current_journey[:entry_station] != nil
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
