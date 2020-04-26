require 'entity_repository'
require 'search_manager'
require 'fields_enrichers/user_enricher'
require_relative './shared_fields_enricher_example'

describe UserEnricher do
  include_examples 'fields_enricher'

  describe '#additional_fields_for' do
    it 'returns corresponding additional fields' do
      additional_fields = { 
        'submitted_ticket_0'    => 'A Catastrophe in Macau',
        'assigned_ticket_0'     => 'A Catastrophe in Pakistan',
        'organization_name'     => 'Xylar'
      }
      user = search_manager.fetch_entity('User', 2)
      expect(subject.enriched_fields(user)).to eq(user.fields.merge(additional_fields))
    end
  end
end