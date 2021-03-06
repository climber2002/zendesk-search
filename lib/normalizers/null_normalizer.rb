require_relative './base_normalizer'

# This Normalizer acts as as a null object and it doesn't do any normalization
require 'singleton'

class NullNormalizer
  include Singleton
  include BaseNormalizer

  private

  def normalize_field_value_impl(value)
    value
  end
end