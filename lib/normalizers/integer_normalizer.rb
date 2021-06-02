require 'singleton'
require_relative './base_normalizer'

class IntegerNormalizer
  include Singleton
  include BaseNormalizer

  private

  def normalize_field_value_impl(value)
    Integer(value)
  end
end