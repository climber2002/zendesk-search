require 'singleton'
require_relative './base_normalizer'

class BooleanNormalizer
  include Singleton
  include BaseNormalizer

  FALSE_VALUES = [false, 'false']
  TRUE_VALUES = [true, 'true']

  private

  def normalize_field_value_impl(value)
    if FALSE_VALUES.include?(value)
      false
    elsif TRUE_VALUES.include?(value)
      true
    else
      raise ArgumentError, "Not boolean value: #{value}"
    end
  end
end