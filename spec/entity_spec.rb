require 'entity_type'
require 'entity'

describe Entity do
  let(:organization_type) { EntityType::ORGANIZATION_TYPE }

  let(:organization_fields) do
    {
      "_id" => 101,
      "url" => "http://initech.zendesk.com/api/v2/organizations/101.json",
      "external_id" => "9270ed79-35eb-4a38-a46f-35725197ea8d",
      "name" => "Enthaze",
      "domain_names" => [
        "kage.com",
        "ecratic.com",
        "endipin.com",
        "zentix.com"
      ],
      "created_at" => "2016-05-21T11:10:28 -10:00",
      "details" => "MegaCorp",
      "shared_tickets" => false,
      "tags" => [
        "Fulton",
        "West",
        "Rodriguez",
        "Farley"
      ]
    }
  end

  describe 'creation' do
    subject { described_class.new(organization_type, fields) }

    context 'when the fields contain all supported field names' do
      let(:fields) { organization_fields }

      it 'gets the entity type set' do
        expect(subject.entity_type).to be organization_type
      end
  
      it 'gets the fields set' do
        expect(subject.fields).to eq organization_fields
      end
    end

    context 'when the fields contain some unsupported fields' do
      let(:fields) { organization_fields.merge("inrelevant" => "nothing") }

      it 'ignores the fields whose field name is not defined in entity_type' do
        expect(subject.fields).to eq organization_fields
      end
    end
    
    context 'when the fields has some field names missing' do
      let(:fields) { organization_fields.delete_if { |k, _| k == 'tags' } }

      it 'creates the entity successfully without those missing fields' do
        expect(subject.fields).to eq fields
        expect(subject.fields.key?('tags')).to eq false
      end
    end

    context 'when the fields has no _id field' do
      let(:fields) { organization_fields.delete_if { |k, _| k == '_id' } }

      it 'raise ArgumentError as _id is a mandatory field' do
        expect { subject }.to raise_error(ArgumentError, '_id is a mandatory field')
      end
    end
  end

  describe '#id' do
    subject { described_class.new(organization_type, organization_fields) }

    it { expect(subject.id).to eq 101 }
  end

  describe '#entity_type_name' do
    subject { described_class.new(organization_type, organization_fields) }

    it { expect(subject.entity_type_name).to eq 'Organization' }
  end
end
