require 'date'
require 'singleton'
require_relative './base_normalizer'

class DateTimeNormalizer
  include Singleton
  include BaseNormalizer

  def normalize_field_value_impl(value)
    DateTime.parse(value)
  end
end