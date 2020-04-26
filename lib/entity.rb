##
# A Entity instance represents an instance of a particular entity type
class Entity
  attr_reader :entity_type, :fields

  def initialize(entity_type, fields)
    check_fields(fields)
    @entity_type = entity_type
    @fields = filter_fields(entity_type, fields)
  end

  def id
    fields['_id']
  end

  def entity_type_name
    entity_type.name
  end

  def field_value_for(field_name)
    fields[field_name]
  end

  private

  def check_fields(fields)
    raise ArgumentError, '_id is a mandatory field' unless fields.include?('_id')
  end

  def filter_fields(entity_type, fields)
    fields.select { |field_name, _| entity_type.supports_field?(field_name) }
  end
end
