require_relative './base_fields_enricher'

class OrganizationEnricher < BaseFieldsEnricher
  def additional_fields_for(organization)
    result = {}
    result.merge!(tickets_fields(organization.id))
    result.merge!(users_fields(organization.id))
    result
  end

  private

  def tickets_fields(organization_id)
    related_entity_fields(organization_id, 'Ticket', 'subject')
  end

  def users_fields(organization_id)
    related_entity_fields(organization_id, 'User', 'name')
  end

  def related_entity_fields(organization_id, related_entity_type, related_entity_field_name)
    ids = search_manager.search_entity_ids(related_entity_type, 'organization_id', organization_id)
    ids.each_with_index.inject({}) do |result, (related_entity_id, index)|
      related_entity = search_manager.fetch_entity(related_entity_type, related_entity_id)
      result["#{related_entity_type.downcase}_#{index}"] = related_entity.field_value_for(related_entity_field_name)
      result
    end
  end
end