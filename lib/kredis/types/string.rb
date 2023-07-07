class Kredis::Types::String < Kredis::Types::Scalar
  typed_as :string

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
