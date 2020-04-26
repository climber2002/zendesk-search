require_relative './normalizing_error'

##
# This is the base class for all normalizers, it provides some basic functionalities
# which are common for all subclasses
module BaseNormalizer

  # Normalize a field value. If field_value is empty, for example, nil or empty string it
  # returns nil, if any errors during normalizing, it will raise NormalizingError.
  # Subclasses should implement `normalize_field_value_impl`
  def normalize_field_value(field_value)
    return nil if empty?(field_value)

    normalize_field_value_impl(field_value)
  rescue StandardError
    raise NormalizingError, "The field value can't be normailized: #{field_value}"
  end

  # Normailze a search query. The `search_term` is usually a string input by the user. By default it
  # just delegate to `normalize_field_value`, however the logic is a bit different if the field is an array.
  def normalize_search_term(search_term)
    normalize_field_value(search_term)
  end

  private

  # If field_value is nil or an empty string or an empty array, then return true
  def empty?(field_value)
    field_value.nil? || (field_value.respond_to?(:empty?) && field_value.empty?)
  end
end