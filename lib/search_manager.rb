require_relative './entity_repository'
require_relative './index_repository'

##
# SearchManager is responsible of indexing and search entites
class SearchManager

  def initialize
    @entity_repository = EntityRepository.new
    @index_repository = IndexRepository.new
  end

  def add_entity(entity)
    entity_repository.add_entity(entity)
    index_repository.index(entity)
  end

  def search_entity_ids(entity_type_name, field_name, search_term)
    index_repository.search(entity_type_name, field_name, search_term)
  end

  def fetch_entity(entity_type_name, entity_id)
    entity_repository.fetch_entity(entity_type_name, entity_id)
  end

  private

  attr_reader :entity_repository, :index_repository
end