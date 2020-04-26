require 'json'
require 'entity_type'
require 'entity'
require 'entity_index'

describe EntityIndex do
  let(:entities) do
    load_entities_from_fixture(entity_type, fixture_file)
  end

  subject { described_class.new(normalizers) }

  describe '#searchable_fields' do
    let(:normalizers) { Normalizer::ORGANIZATION_NORMALIZERS }

    it 'get searchable_fields of Organization' do
      expected_field_names = ["_id", "url", "external_id", "name", "domain_names", "created_at",
                              "details", "shared_tickets", "tags"]
      expect(subject.searchable_fields).to eq expected_field_names
    end
  end

  describe '#search' do
    before do
      entities.each { |entity| subject.index(entity) }
    end

    describe 'search organizations' do
      let(:fixture_file) { 'organizations.json' }
      let(:entity_type) { EntityType::ORGANIZATION_TYPE }
      let(:normalizers) { Normalizer::ORGANIZATION_NORMALIZERS }

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

    describe 'search users' do
      let(:fixture_file) { 'users.json' }
      let(:entity_type) { EntityType::USER_TYPE }
      let(:normalizers) { Normalizer::USER_NORMALIZERS }

      it 'can search organization_id' do
        expect(subject.search('organization_id', '101')).to eq [1]
      end

      it 'can search locale' do
        expect(subject.search('locale', 'en-AU')).to eq [1, 3]
        expect(subject.search('locale', 'en-au')).to eq [1, 3]
        expect(subject.search('locale', 'en')).to eq []
      end

      it 'can search signature' do
        expect(subject.search('signature', 'dont worry be happy')).to eq [1, 2, 3]
        expect(subject.search('signature', "Don't Worry Be Happy!")).to eq [1, 2, 3]
      end
    end
    
    describe 'search tickets' do
      let(:fixture_file) { 'tickets.json' }
      let(:entity_type) { EntityType::TICKET_TYPE }
      let(:normalizers) { Normalizer::TICKET_NORMALIZERS }

      it 'can search _id by full match' do
        expect(subject.search('_id', '436bf9b0-1147-4c0a-8439-6f79833bff5b')).to eq ['436bf9b0-1147-4c0a-8439-6f79833bff5b']
        expect(subject.search('_id', '436bf9b0')).to eq []
      end

      it 'can search via' do
        expect(subject.search('via', 'chat')).to eq ['1a227508-9f39-427c-8f57-1b72f3fab87c']
      end
    end
  end
end