require_relative './search_error'

##
# EntityRepository is a repository that stores all entities. It maintains a EntityStore
# for each type of entity. Each entity is stored in its own entity_store
class EntityRepository

  def initialize
    @entity_stores = {}
  end

  def add_entity(entity)
    entity_type_name = entity.entity_type_name
    entity_store = entity_store_for(entity_type_name) || create_entity_store_for(entity_type_name)
    entity_store.add_entity(entity)
  end

  def fetch_entity(entity_type_name, id)
    entity_store = entity_store_for(entity_type_name) 
    raise SearchError, "Entity store for #{entity_type_name} not exist" if entity_store.nil?

    entity_store.fetch_entity_by(id)
  end

  private

  attr_reader :entity_stores

  def entity_store_for(entity_type_name)
    entity_stores[entity_type_name]
  end

  def create_entity_store_for(entity_type_name)
    entity_store = EntityStore.new(entity_type_name)
    entity_stores[entity_type_name] = entity_store
    entity_store
  end

  # The EntityStore is a helper class which manages entities
  # for a particular type, it's only used inside EntityRepository
  class EntityStore
    def initialize(entity_type_name)
      @entity_type_name = entity_type_name
      @entities = {}
    end

    def add_entity(entity)
      raise SearchError, "Id #{entity.id} already exists for #{entity.entity_type_name}" if contains?(entity)
      entities[entity.id] = entity
    end

    def fetch_entity_by(id)
      entities.fetch(id) { |_| raise SearchError, "Id #{id} doesn't exist for #{entity_type_name}" }
    end

    private

    attr_reader :entity_type_name, :entities

    def contains?(entity)
      entities.key?(entity.id)
    end
  end
end