##
# This class defines an entity type, for example Organization or User, and also
# it defines the attributes that it supported
class EntityType
  ORGANIZATION_FIELDS = ['_id', 'url', 'external_id', 'name', 'domain_names',
                         'created_at', 'details', 'shared_tickets', 'tags']

  attr_reader :name, :field_names

  def initialize(name, field_names)
    @name = name
    @field_names = field_names
  end

  def supports_field?(field_name)
    field_names.include?(String(field_name))
  end

  ORGANIZATION_TYPE = EntityType.new('Organization', ORGANIZATION_FIELDS)
end