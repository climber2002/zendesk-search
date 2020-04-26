require 'entity_repository'

describe EntityRepository do
  subject { EntityRepository.new }

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

  describe '#fetch_entity and #add_entity' do
    before do
      subject.add_entity(build_organization)
    end

    it 'raises SearchError if the entity type or entity id does NOT exist' do
      expected_exception_msg = "Id 125 doesn't exist"
      expect { subject.fetch_entity('Organization', 125) }.to raise_error(SearchError, expected_exception_msg)
    end

    it 'fetches the entity if the id exists' do
      expect(subject.fetch_entity('Organization', 101).fields).to eq organization_fields
    end

    it 'raises SearchError if the id already exists when add entity' do
      expected_exception_msg = 'Id 101 already exists for Organization'
      expect { subject.add_entity(build_organization) }.to raise_error(SearchError, expected_exception_msg)
    end
  end
  
  def build_organization
    Entity.new(EntityType::ORGANIZATION_TYPE, organization_fields)
  end
end