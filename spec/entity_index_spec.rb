# require 'entity_loader'

# describe EntityIndex do
#   let(:organizations_loader) { EntityLoader.new(EntityType::ORGANIZATION_TYPE, 'organizations.json') }
#   let(:organizations) { organizations_loader.load }

#   let(:organization_normalizers) { described_class::ORGANIZATION_NORMALIZERS }
#   subject { described_class.new(organization_normalizers) }

#   before do
#     organizations.each do |organization_entity|
#       subject.index(organization_entity)
#     end
#   end

#   describe '#search' do
#     it 'can search _id' do
#       search_result = subject.search('_id', '105')
#       expect(search_result.count).to eq 1
#       fields = search_result.first.fields
#       expect(fields['name']).to eq 'Koffee'
#       expect(fields['external_id']).to eq '52f12203-6112-4fb9-aadc-70a6c816d605'
#     end
#   end
# end