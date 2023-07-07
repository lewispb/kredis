require "json"
require "active_model/type"
require "kredis/type/json"
require "kredis/type/datetime"

module Kredis::TypeCasting
  extend ActiveSupport::Concern

  class InvalidType < StandardError; end

  class_methods do
    def typed_as(type)
      self.type_as = type
    end
  end

  TYPES = {
    string: ActiveModel::Type::String.new,
    integer: ActiveModel::Type::Integer.new,
    decimal: ActiveModel::Type::Decimal.new,
    float: ActiveModel::Type::Float.new,
    boolean: ActiveModel::Type::Boolean.new,
    datetime: Kredis::Type::DateTime.new,
    json: Kredis::Type::Json.new
  }

  def typed=(type)
    self.type_as = type
  end

  def type_to_string(value)
    type.serialize(value)
  end

  def string_to_type(value)
    type.cast(value)
  end

  def types_to_strings(values)
    Array(values).flatten.map { |value| type_to_string(value) }
  end

  def strings_to_types(values)
    Array(values).flatten.map { |value| string_to_type(value) }
  end

  private
    def type
      raise InvalidType if type_as && !TYPES.key?(type_as)

      TYPES[type_as || :string]
    end
end
