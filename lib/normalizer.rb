require_relative './normalizers/array_normalizer'
require_relative './normalizers/boolean_normalizer'
require_relative './normalizers/date_time_normalizer'
require_relative './normalizers/integer_normalizer'
require_relative './normalizers/null_normalizer'
require_relative './normalizers/text_normalizer.rb'

##
# This module just declares some constants for each normalizer we need. There are two places that we need do normalization:
# 1. When indexing fields of an entity, for example we might want to normalize `MegaCörp` to `megacorp`, or normalize
#    a datetime string into a datetime object so we can perform range search
# 2. When the user inputs a search query, we need to also normalize the query first using the same logic when indexing
#    the field before we do the search, otherwise we can't match the terms
#
# So we require each normalizer implements two methods,
# - normalize_field_value: This is called when indexing an entity, it can throw exception to show that the field value is not valid
# - normalize_search_term: Usually the search term is a string, and we need to normalize it into a value that we can 
#   do comparision with the terms stored in inverted_index
#
# For each normalizer's implementation, check `normailizers` folder
module Normalizer
  NULL_NORMALIZER           = NullNormalizer.instance
  BOOLEAN_NORMALIZER        = BooleanNormalizer.instance
  DATE_TIME_NORMALIZER      = DateTimeNormalizer.instance
  INTEGER_NORMALIZER        = IntegerNormalizer.instance
  TEXT_NORMALIZER           = TextNormalizer.instance
  TEXT_ARRAY_NORMALIZER     = ArrayNormalizer.new(TEXT_NORMALIZER) # e.g. tags should be normalized as text
  NULL_ARRAY_NORMALIZER     = ArrayNormalizer.new(NULL_NORMALIZER) # e.g. domain_names shouldn't drop the '.'

  ORGANIZATION_NORMALIZERS = {
    '_id'               => INTEGER_NORMALIZER,
    'url'               => NULL_NORMALIZER,
    'external_id'       => NULL_NORMALIZER,
    'name'              => TEXT_NORMALIZER,
    'domain_names'      => NULL_ARRAY_NORMALIZER,
    'created_at'        => DATE_TIME_NORMALIZER,
    'details'           => TEXT_NORMALIZER,
    'shared_tickets'    => BOOLEAN_NORMALIZER,
    'tags'              => TEXT_ARRAY_NORMALIZER
  }

  USER_NORMALIZERS = {
    '_id'               => INTEGER_NORMALIZER,
    'url'               => NULL_NORMALIZER,
    'external_id'       => NULL_NORMALIZER,
    'name'              => TEXT_NORMALIZER,
    'alias'             => TEXT_NORMALIZER,
    'created_at'        => DATE_TIME_NORMALIZER,
    'active'            => BOOLEAN_NORMALIZER,
    'verified'          => BOOLEAN_NORMALIZER,
    'shared'            => BOOLEAN_NORMALIZER,
    'locale'            => TEXT_NORMALIZER,
    'timezone'          => TEXT_NORMALIZER,
    'last_login_at'     => DATE_TIME_NORMALIZER,
    'email'             => NULL_NORMALIZER,
    'phone'             => TEXT_NORMALIZER,
    'signature'         => TEXT_NORMALIZER,
    'organization_id'   => INTEGER_NORMALIZER,
    'tags'              => TEXT_ARRAY_NORMALIZER,
    'suspended'         => BOOLEAN_NORMALIZER,
    'role'              => TEXT_NORMALIZER
  }

  TICKET_NORMALIZERS = {
    '_id'               => NULL_NORMALIZER,
    'url'               => NULL_NORMALIZER,
    'external_id'       => NULL_NORMALIZER,
    'created_at'        => DATE_TIME_NORMALIZER,
    'type'              => TEXT_NORMALIZER,
    'subject'           => TEXT_NORMALIZER,
    'description'       => TEXT_NORMALIZER,
    'priority'          => TEXT_NORMALIZER,
    'status'            => TEXT_NORMALIZER,
    'submitter_id'      => INTEGER_NORMALIZER,
    'assignee_id'       => INTEGER_NORMALIZER,
    'organization_id'   => INTEGER_NORMALIZER,
    'tags'              => TEXT_ARRAY_NORMALIZER,
    'has_incidents'     => BOOLEAN_NORMALIZER,
    'due_at'            => DATE_TIME_NORMALIZER,
    'via'               => TEXT_NORMALIZER
  }
end

