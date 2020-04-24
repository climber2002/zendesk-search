##
# This class defines an entity type, for example Organization or User, and also
# it defines the attributes that it supported
class EntityType
  ORGANIZATION_FIELDS = ['_id', 'url', 'external_id', 'name', 'domain_names',
                         'created_at', 'details', 'shared_tickets', 'tags']

  USER_FIELDS         = ['_id', 'url', 'external_id', 'name', 'alias', 'created_at',
                         'active', 'verified', 'shared', 'locale', 'timezone',
                         'last_login_at', 'email', 'phone', 'signature', 'organization_id',
                         'tags', 'suspended', 'role']

  TICKET_FIELDS       = ['_id', 'url', 'external_id', 'created_at', 'type', 'subject',
                         'description', 'priority', 'status', 'submitter_id', 'assignee_id',
                         'organization_id', 'tags', 'has_incidents', 'due_at', 'via']

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
