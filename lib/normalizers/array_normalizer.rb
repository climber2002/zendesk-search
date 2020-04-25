require_relative './base_normalizer'

class ArrayNormalizer
  include BaseNormalizer

  def initialize(element_normalizer)
    @element_normalizer = element_normalizer
  end

  def normalize_field_impl(value)
    Array(value).map do |element|
      element_normalizer.normalize_field(element)
    end
  end

  def normalize_search_query(search_query)
    element_normalizer.normalize_search_query(search_query)
  end

  private

  attr_reader :element_normalizer
end