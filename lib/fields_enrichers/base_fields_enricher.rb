##
# The fields enricher is used to enrich the fields of an entity, for example, the organization needs to also
# return the tickets and users, this is the base class for all enrichers, subclasses only need to define
# `additional_fields_for` method
class BaseFieldsEnricher
  def initialize(search_manager)
    @search_manager = search_manager
  end

  # The subclasses only need to define `additional_fields_for`
  def enriched_fields(entity)
    original_fields = entity.fields
    additional_fields = additional_fields_for(entity)
    original_fields.merge(additional_fields)
  end

  protected

  attr_reader :search_manager

  ## 
  # Fetch the name of a related entity. It assumes the in related entity the name field is just `name`,
  # and in the result the key will be `#{related_field_name}_name`
  def related_entity_name(main_entity, related_field_name, related_entity_type)
    related_entity_id = main_entity.field_value_for("#{related_field_name}_id")
    return {} if related_entity_id.nil?

    related_entity = search_manager.fetch_entity(related_entity_type, related_entity_id)
    related_entity.nil? ? {} : { "#{related_field_name}_name" => related_entity.field_value_for('name') }
  end
end