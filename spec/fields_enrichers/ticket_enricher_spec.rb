require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/ticket_enricher'
require_relative './shared_fields_enricher_example'

describe TicketEnricher do
  
  include_examples 'fields_enricher'

  describe '#additional_fields_for' do
    it 'returns corresponding additional fields' do
      additional_fields = { 
        'submitter'  => 'Francisca Rasmussen',
        'assignee'  => 'Cross Barlow',
        'organization'    => 'Enthaze'
      }
      ticket = search_manager.fetch_entity('Ticket', '81bdd837-e955-4aa4-a971-ef1e3b373c6d')
      expect(subject.enriched_fields(ticket)).to eq(ticket.fields.merge(additional_fields))
    end

    it 'raises SearchError if the related entity id does NOT exist' do
      # submitter_id and assignee_id can't be found in users
      ticket = search_manager.fetch_entity('Ticket', 'a25f90f3-2157-4585-bbee-360367a2c1e8')
      expect { subject.enriched_fields(ticket) }.to raise_error(SearchError)
    end
  end
end