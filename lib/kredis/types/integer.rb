class Kredis::Types::Integer < Kredis::Types::Scalar
  typed_as :integer

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
