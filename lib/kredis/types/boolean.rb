class Kredis::Types::Boolean < Kredis::Types::Scalar
  typed_as :boolean

  def initialize(config, key, default: nil, expires_in: nil)
    super
  end
end
