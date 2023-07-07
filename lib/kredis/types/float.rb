class Kredis::Types::Float < Kredis::Types::Scalar
  typed_as :float

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
