require_relative './entity_index'
require_relative './search_error'

##
# IndexRepository manages the entity_index for each EntityType
class IndexRepository
  def initialize
    @entity_indices = {
      'Organization'  => EntityIndex.new(Normalizer::ORGANIZATION_NORMALIZERS),
      'User'          => EntityIndex.new(Normalizer::USER_NORMALIZERS),
      'Ticket'        => EntityIndex.new(Normalizer::TICKET_NORMALIZERS)
    }
  end

  def index(entity)
    entity_index = entity_index_for(entity.entity_type_name)
    entity_index.index(entity)
  end

  def search(entity_type_name, field_name, search_term)
    entity_index = entity_index_for(entity_type_name)
    entity_index.search(field_name, search_term)
  end

  private

  attr_reader :entity_indices

  def entity_index_for(entity_type_name)
    entity_indices.fetch(entity_type_name) do |_|
      raise SearchError, "The entity type doesn't exist: #{entity_type_name}"
    end
  end
end