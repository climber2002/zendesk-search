##
# This is the base class for all normalizers, it provides some basic functionalities
# which are common for all subclasses
module BaseNormalizer

  # if search_query is nil or emtpy string it returns nil ,otherwise subclasses should implement
  # `normalize_search_query_impl`. This function should never raise exception so if the search_query
  # can't be normalized then just return the original search_query
  def normalize_search_query(search_query)
    return nil if String(search_query).empty?

    normalize_search_query_impl(search_query)
  rescue StandardError
    search_query
  end

  private

  # By default the `normalize_search_query_impl` just calls `normalize_field_value`
  def normalize_search_query_impl(search_query)
    normalize_field(search_query)
  end
end