RSpec.shared_examples "fields_enricher" do |_|
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
end