require_relative './entity_repository'
require_relative './index_repository'
require_relative './fields_enrichers/organization_enricher'
require_relative './fields_enrichers/ticket_enricher'
require_relative './fields_enrichers/user_enricher'

##
# SearchManager is responsible of indexing and search entites
class SearchManager

  def initialize
    @entity_repository = EntityRepository.new
    @index_repository = IndexRepository.new
    @fields_enrichers = {
      'Organization'    => OrganizationEnricher.new(self),
      'User'            => UserEnricher.new(self),
      'Ticket'          => TicketEnricher.new(self)
    }
  end

  def add_entity(entity)
    entity_repository.add_entity(entity)
    index_repository.index(entity)
  end

  def search_entities(entity_type_name, field_name, search_term)
    entity_ids = search_entity_ids(entity_type_name, field_name, search_term)
    entity_ids.map do |entity_id|
      entity = fetch_entity(entity_type_name, entity_id)
      fields_enricher_for(entity_type_name).enriched_fields(entity)
    end
  end

  def search_entity_ids(entity_type_name, field_name, search_term)
    index_repository.search(entity_type_name, field_name, search_term)
  end

  def fetch_entity(entity_type_name, entity_id)
    entity_repository.fetch_entity(entity_type_name, entity_id)
  end

  private

  attr_reader :entity_repository, :index_repository, :fields_enrichers

  def fields_enricher_for(entity_type_name)
    fields_enrichers.fetch(entity_type_name) do |_|
      raise SearchError, "The fields enricher is not found for #{entity_type_name}"
    end
  end
end