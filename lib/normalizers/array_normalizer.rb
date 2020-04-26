require_relative './base_normalizer'

class ArrayNormalizer
  include BaseNormalizer

  def initialize(element_normalizer)
    @element_normalizer = element_normalizer
  end

  def normalize_field_value_impl(value)
    Array(value).map do |element|
      element_normalizer.normalize_field_value(element)
    end
  end

  def normalize_search_term(search_term)
    element_normalizer.normalize_search_term(search_term)
  end

  private

  attr_reader :element_normalizer
end