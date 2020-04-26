require_relative './normalizer'
require_relative './search_error'

##
# The EntityIndex maintains the inverted indices for a particular EntityType. Each
# searchable field has its own inverted index. When create an EntityIndex instance, 
# it should be passed a list of normalizers so each searchable field has its own normalizer,
# check the comments in normalizer to find out why we need normalizer
class EntityIndex
  ORGANIZATION_NORMALIZERS = {
    '_id'               => Normalizer::INTEGER_NORMALIZER,
    'url'               => Normalizer::NULL_NORMALIZER,
    'external_id'       => Normalizer::NULL_NORMALIZER,
    'name'              => Normalizer::TEXT_NORMALIZER,
    'domain_names'      => Normalizer::NULL_ARRAY_NORMALIZER,
    'created_at'        => Normalizer::DATE_TIME_NORMALIZER,
    'details'           => Normalizer::TEXT_NORMALIZER,
    'shared_tickets'    => Normalizer::BOOLEAN_NORMALIZER,
    'tags'              => Normalizer::TEXT_ARRAY_NORMALIZER
  }

  USER_NORMALIZERS = {
    '_id'               => Normalizer::INTEGER_NORMALIZER,
    'url'               => Normalizer::NULL_NORMALIZER,
    'external_id'       => Normalizer::NULL_NORMALIZER,
    'name'              => Normalizer::TEXT_NORMALIZER,
    'alias'             => Normalizer::TEXT_NORMALIZER,
    'created_at'        => Normalizer::DATE_TIME_NORMALIZER,
    'active'            => Normalizer::BOOLEAN_NORMALIZER,
    'verified'          => Normalizer::BOOLEAN_NORMALIZER,
    'shared'            => Normalizer::BOOLEAN_NORMALIZER,
    'locale'            => Normalizer::TEXT_NORMALIZER,
    'timezone'          => Normalizer::TEXT_NORMALIZER,
    'last_login_at'     => Normalizer::DATE_TIME_NORMALIZER,
    'email'             => Normalizer::NULL_NORMALIZER,
    'phone'             => Normalizer::TEXT_NORMALIZER,
    'signature'         => Normalizer::TEXT_NORMALIZER,
    'organization_id'   => Normalizer::INTEGER_NORMALIZER,
    'tags'              => Normalizer::TEXT_ARRAY_NORMALIZER,
    'suspended'         => Normalizer::BOOLEAN_NORMALIZER,
    'role'              => Normalizer::TEXT_NORMALIZER
  }

  TICKET_NORMALIZERS = {
    '_id'               => Normalizer::NULL_NORMALIZER,
    'url'               => Normalizer::NULL_NORMALIZER,
    'external_id'       => Normalizer::NULL_NORMALIZER,
    'created_at'        => Normalizer::DATE_TIME_NORMALIZER,
    'type'              => Normalizer::TEXT_NORMALIZER,
    'subject'           => Normalizer::TEXT_NORMALIZER,
    'description'       => Normalizer::TEXT_NORMALIZER,
    'priority'          => Normalizer::TEXT_NORMALIZER,
    'status'            => Normalizer::TEXT_NORMALIZER,
    'submitter_id'      => Normalizer::INTEGER_NORMALIZER,
    'assignee_id'       => Normalizer::INTEGER_NORMALIZER,
    'organization_id'   => Normalizer::INTEGER_NORMALIZER,
    'tags'              => Normalizer::TEXT_ARRAY_NORMALIZER,
    'has_incidents'     => Normalizer::BOOLEAN_NORMALIZER,
    'due_at'            => Normalizer::DATE_TIME_NORMALIZER,
    'via'               => Normalizer::TEXT_NORMALIZER
  }

  def initialize(field_normalizers)
    @field_normalizers = field_normalizers
    @field_indices = field_normalizers.reduce({}) do |indices, (field_name, _)|
      indices[field_name] = InvertedIndex.new
      indices
    end
  end

  def index(entity)
    entity_id = entity.id
    fields = entity.fields
    field_normalizers.each do |field_name, normalizer|
      field_value = fields[field_name]
      index_field(field_name, field_value, normalizer, entity_id)
    end
  end

  def search(field_name, search_term)
    normalizer = normalizer_for(field_name)
    normalized_term = normalizer.normalize_search_term(search_term)
    index_for(field_name).search(normalized_term)
  rescue NormalizingError
    # if any error normalizing, for example search 'abcd' against an interger field, just return empty result
    []
  end

  private

  attr_reader :field_normalizers, :field_indices

  def index_field(field_name, field_value, normalizer, entity_id)
    normalized_value = normalizer.normalize_field_value(field_value)
    tokenized_terms = tokenize(normalized_value)
    field_index = index_for(field_name)
    field_index.index(tokenized_terms, entity_id)
  end

  def index_for(field_name)
    field_indices[field_name]
  end

  # For the requirements we don't need tokenize as it only requires full value match, but if
  # can search substrings we need to create tokenizer, for example split into words separated by space
  def tokenize(normalized_value)
    Array(normalized_value)
  end

  def normalizer_for(field_name)
    field_normalizers.fetch(field_name) { |_| raise SearchError, "The field #{field_name} is not a searchable field." }
  end
end