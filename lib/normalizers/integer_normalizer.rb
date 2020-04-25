require 'singleton'
require_relative './base_normalizer'

class IntegerNormalizer
  include Singleton
  include BaseNormalizer

  def normalize_field_impl(value)
    Integer(value)
  end
end