##
# A Entity instance represents an instance of a particular entity type
class Entity
  attr_reader :entity_type, :fields

  def initialize(entity_type, fields)
    @entity_type = entity_type
    @fields = filter_fields(entity_type, fields)
  end

  def id
    fields['_id']
  end

  private

  def filter_fields(entity_type, fields)
    fields.select { |field_name, _| entity_type.supports_field?(field_name) }
  end
end
