require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/user_enricher'

describe UserEnricher do
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
        'submitted_ticket_0'  => 'A Catastrophe in Macau',
        'assigned_ticket_0'  => 'A Catastrophe in Pakistan',
        'organization'    => 'Xylar'
      }
      user = search_manager.fetch_entity('User', 2)
      expect(subject.enriched_fields(user)).to eq(user.fields.merge(additional_fields))
    end
  end
end