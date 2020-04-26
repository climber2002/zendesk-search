require 'index_repository'

describe IndexRepository do
  subject { described_class.new }

  let(:organizations) { load_entities(EntityType::ORGANIZATION_TYPE, 'organizations.json') }
  let(:users)         { load_entities(EntityType::USER_TYPE, 'users.json') }
  let(:tickets)       { load_entities(EntityType::TICKET_TYPE, 'tickets.json') }

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

  def load_entities(entity_type, fixture_file)
    fixture = File.read(File.join(File.dirname(__FILE__), './fixtures', fixture_file))
    JSON.parse(fixture).map do |fields|
      Entity.new(entity_type, fields)
    end
  end
end