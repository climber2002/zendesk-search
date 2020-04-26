require 'json'
require 'entity_type'
require 'entity'
require 'entity_index'

describe EntityIndex do
  let(:organization_type) { EntityType::ORGANIZATION_TYPE }
  let(:organizations) do
    organization_fixture = File.read(File.join(File.dirname(__FILE__), './fixtures/organizations.json'))
    JSON.parse(organization_fixture).map do |fields|
      Entity.new(organization_type, fields)
    end
  end

  let(:organization_normalizers) { described_class::ORGANIZATION_NORMALIZERS }
  subject { described_class.new(organization_normalizers) }

  before do
    organizations.each do |organization_entity|
      subject.index(organization_entity)
    end
  end

  describe '#search' do
    it 'raises error if the field is not recognizable' do
      expect { subject.search('not_exist', 'abcd') }.to raise_error(SearchError)
    end

    it 'can search _id' do
      expect(subject.search('_id', '107')).to eq [107]
      expect(subject.search('_id', 'abcd')).to eq []
    end

    it 'can search boolean' do
      expect(subject.search('shared_tickets', 'false')).to eq [101, 104]
      expect(subject.search('shared_tickets', 'abcd')).to eq []
    end

    it 'can search text' do
      expect(subject.search('details', 'MegaCorp')).to eq [101, 104, 107]
      expect(subject.search('details', 'MegaCörp')).to eq [101, 104, 107]
      expect(subject.search('details', 'megacorp')).to eq [101, 104, 107]
    end

    it 'can search datetime if the datetime values are equal' do
      expect(subject.search('created_at', '2016-05-21T11:10:28 -10:00')).to eq [101]
      expect(subject.search('created_at', '2016-05-21T10:10:28 -11:00')).to eq [101]
    end

    it 'can search array and matches any value in the array' do
      expect(subject.search('tags', 'West')).to eq [101]
      expect(subject.search('tags', 'west')).to eq [101]
    end

    it 'can search empty boolean' do
      expect(subject.search('shared_tickets', '')).to eq [122]
    end

    it 'can search empty text' do
      expect(subject.search('details', '')).to eq [122]
    end

    it 'can search empty array' do
      expect(subject.search('domain_names', '')).to eq [104, 107]
    end
  end
end