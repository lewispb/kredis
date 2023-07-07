class Kredis::Types::Cycle < Kredis::Types::Counter
  callback_after_change_for :next, :reset

  attr_accessor :values

  alias index value

  def value
    values[index]
  end

  def next
    set (index + 1) % values.size
  end
end
