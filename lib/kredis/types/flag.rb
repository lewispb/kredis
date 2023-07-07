class Kredis::Types::Flag < Kredis::Types::Proxying
  proxying :set, :exists?, :del
  callback_after_change_for :mark, :remove

  attr_accessor :expires_in

  def initialize(config, key, expires_in: nil)
    super
  end

  def mark(expires_in: nil, force: true)
    set 1, ex: expires_in || self.expires_in, nx: !force
  end

  def marked?
    exists?
  end

  def remove
    del
  end
end
