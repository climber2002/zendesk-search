require 'entity_type'

describe EntityType do
  describe 'creation' do
    subject { described_class.new('Organization', EntityType::ORGANIZATION_FIELDS) }

    it 'can create an entity type' do
      expect(subject.name).to eq 'Organization'
      expect(subject.field_names).to eq EntityType::ORGANIZATION_FIELDS
    end
  end

  describe '#support_field?' do
    subject { described_class.new('Organization', EntityType::ORGANIZATION_FIELDS) }

    it 'returns true if the field_name is defined in supported fields' do
      expect(subject.supports_field?('url')).to eq true
    end

    it 'returns false if the field_name is NOT defined in supported fields' do
      expect(subject.supports_field?('inrelevant')).to eq false
    end
  end
end
