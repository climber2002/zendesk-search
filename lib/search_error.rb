##
# The application throw this exception if any errors occured during search, for example if the field
# is not a searchable field
class SearchError < StandardError; end