require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/organization_enricher'
require_relative './shared_fields_enricher_example'

describe OrganizationEnricher do

  include_examples 'fields_enricher'
  
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