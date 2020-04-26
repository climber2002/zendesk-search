require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/ticket_enricher'

describe TicketEnricher do
  let(:organizations) { load_entities_from_fixture(EntityType::ORGANIZATION_TYPE, 'organizations.json') }
  let(:users)         { load_entities_from_fixture(EntityType::USER_TYPE, 'users.json') }
  let(:tickets)       { load_entities_from_fixture(EntityType::TICKET_TYPE, 'tickets.json') }

  let(:search_manager) { SearchManager.new }

  before do
    [organizations, users, tickets].each do |entities|
      entities.each { |entity| search_manager.add_entity(entity) }
    end
  end

  subject { described_class.new(search_manager) }

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
  end
end