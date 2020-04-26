require_relative './base_fields_enricher'

class TicketEnricher < BaseFieldsEnricher
  def additional_fields_for(ticket)
    result = {}
    result.merge!(related_entity_name(ticket, 'submitter', 'User'))
    result.merge!(related_entity_name(ticket, 'assignee', 'User'))
    result.merge!(related_entity_name(ticket, 'organization', 'Organization'))
    result
  end
end