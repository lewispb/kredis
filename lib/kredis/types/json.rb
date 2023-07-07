class Kredis::Types::Json < Kredis::Types::Scalar
  typed_as :json

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
