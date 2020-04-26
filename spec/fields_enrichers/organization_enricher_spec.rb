require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/organization_enricher'

describe OrganizationEnricher do
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
        'ticket_0'  => 'A Catastrophe in Korea (North)',
        'ticket_1'  => 'A Catastrophe in Pakistan',
        'user_0'    => 'Francisca Rasmussen'
      }
      organization = search_manager.fetch_entity('Organization', 101)
      expect(subject.enriched_fields(organization)).to eq(organization.fields.merge(additional_fields))
    end
  end
end