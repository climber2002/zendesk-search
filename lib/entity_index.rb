require_relative './normalizer'
require_relative './search_error'
require_relative './inverted_index'

##
# The EntityIndex maintains the inverted indices for a particular EntityType. Each
# searchable field has its own inverted index. When create an EntityIndex instance, 
# it should be passed a list of normalizers so each searchable field has its own normalizer,
# check the comments in normalizer to find out why we need normalizer
class EntityIndex

  ##
  # The field_normaizers is a hash which maps the field_name to the corresponding normalizer
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

  def searchable_fields
    @searchable_fields ||= field_normalizers.keys
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