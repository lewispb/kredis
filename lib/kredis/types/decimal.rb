class Kredis::Types::Decimal < Kredis::Types::Scalar
  typed_as :decimal

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
