require_relative './base_fields_enricher'

class UserEnricher < BaseFieldsEnricher
  def additional_fields_for(user)
    result = {}
    result.merge!(submitted_tickets(user.id))
    result.merge!(assigned_tickets(user.id))
    result.merge!(related_entity_field(user, 'organization', 'Organization'))
    result
  end

  private

  def submitted_tickets(submitter_id)
    related_tickets(submitter_id, 'submitter_id', 'submitted')  
  end

  def assigned_tickets(asignee_id)
    related_tickets(asignee_id, 'assignee_id', 'assigned')
  end

  def related_tickets(user_id, user_field_name_in_ticket, ticket_field_prefix)
    ticket_ids = search_manager.search_entity_ids('Ticket', user_field_name_in_ticket, user_id)
    ticket_ids.each_with_index.inject({}) do |result, (ticket_id, index)|
      ticket = search_manager.fetch_entity('Ticket', ticket_id)
      result["#{ticket_field_prefix}_ticket_#{index}"] = ticket.field_value_for('subject')
      result
    end
  end
end