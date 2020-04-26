##
# The application throw this exception if any errors occurred during search, for example if the field
# is not a searchable field
class SearchError < StandardError; end