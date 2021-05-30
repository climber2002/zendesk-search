require_relative './normalizer'

##
# This class defines an entity type, for example Organization or User, and also
# it defines the fields that the entity supported
class EntityType
  ORGANIZATION_FIELDS = Normalizer::ORGANIZATION_NORMALIZERS.keys

  USER_FIELDS         = Normalizer::USER_NORMALIZERS.keys

  TICKET_FIELDS       = Normalizer::TICKET_NORMALIZERS.keys

  attr_reader :name, :field_names

  def initialize(name, field_names)
    @name = name
    @field_names = field_names
  end

  def supports_field?(field_name)
    field_names.include?(String(field_name))
  end

  ORGANIZATION_TYPE   = EntityType.new('Organization', ORGANIZATION_FIELDS)
  USER_TYPE           = EntityType.new('User', USER_FIELDS)
  TICKET_TYPE         = EntityType.new('Ticket', TICKET_FIELDS)
end
