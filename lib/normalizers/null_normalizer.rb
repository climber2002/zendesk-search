require_relative './base_normalizer'

# This Normalizer acts as as a null object and it doesn't do any normalization
require 'singleton'

class NullNormalizer
  include Singleton
  include BaseNormalizer

  def normalize_field(value)
    value
  end
end