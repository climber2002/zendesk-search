require 'index_repository'

describe IndexRepository do
  subject { described_class.new }

  let(:organizations) { load_entities_from_fixture(EntityType::ORGANIZATION_TYPE, 'organizations.json') }
  let(:users)         { load_entities_from_fixture(EntityType::USER_TYPE, 'users.json') }
  let(:tickets)       { load_entities_from_fixture(EntityType::TICKET_TYPE, 'tickets.json') }

  before do
    [organizations, users, tickets].each do |entities|
      entities.each { |entity| subject.index(entity) }
    end
  end

  it 'can search organizations' do
    expect(subject.search('Organization', '_id', '101')).to eq [101]
  end

  it 'can search users' do
    expect(subject.search('User', 'tags', 'foxworth')).to eq [2]
  end

  it 'can search tickets' do
    expect(subject.search('Ticket', 'status', 'hold')).to eq ['1a227508-9f39-427c-8f57-1b72f3fab87c']
  end
end