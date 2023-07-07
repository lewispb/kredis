class Kredis::Types::Datetime < Kredis::Types::Scalar
  typed_as :datetime

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
