require 'entity_type'
require 'entity_loader'

describe EntityLoader do
  let(:organization_type) { EntityType::ORGANIZATION_TYPE }
  let(:filename) { 'organizations.json' }

  let(:entity_loader) { described_class.new(organization_type, filename) }

  describe '#load' do
    subject(:entities) { entity_loader.load }

    it 'should load all organization entities' do
      expect(entities.size).to eq 25
    end

    it 'keeps the order of organizations' do
      expect(entities.first.id).to eq 101
      expect(entities.last.id).to eq 125
    end
  end
end
