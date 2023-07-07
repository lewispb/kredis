class Kredis::Types::Counter < Kredis::Types::Proxying
  proxying :multi, :set, :incrby, :decrby, :get, :del, :exists?
  callback_after_change_for :increment, :decrement, :reset

  attr_accessor :expires_in

  def initialize(config, key, expires_in: nil)
    super
  end

  def increment(by: 1)
    multi do
      set 0, ex: expires_in, nx: true
      incrby by
    end[-1]
  end

  def decrement(by: 1)
    multi do
      set 0, ex: expires_in, nx: true
      decrby by
    end[-1]
  end

  def value
    get.to_i
  end

  def reset
    del
  end
end
