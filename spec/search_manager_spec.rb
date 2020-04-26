describe SearchManager do
  let(:organizations) { load_entities_from_fixture(EntityType::ORGANIZATION_TYPE, 'organizations.json') }
  let(:users)         { load_entities_from_fixture(EntityType::USER_TYPE, 'users.json') }
  let(:tickets)       { load_entities_from_fixture(EntityType::TICKET_TYPE, 'tickets.json') }

  subject { SearchManager.new }

  before do
    [organizations, users, tickets].each do |entities|
      entities.each { |entity| subject.add_entity(entity) }
    end
  end

  describe '#search_entities' do
    it 'can search users with enriched fields' do
      expected = [
        {
          '_id'                 => 1,
          'active'              => true,
          'alias'               => 'Miss Coffey',
          'assigned_ticket_0'   => 'A Catastrophe in Macau',
          'created_at'          => '2016-04-15T05:19:46 -10:00',
          'email'               => 'coffeyrasmussen@flotonic.com',
          'external_id'         => '74341f74-9c79-49d5-9611-87ef9b6eb75f',
          'last_login_at'       => '2013-08-04T01:03:27 -10:00',
          'locale'              => 'en-AU',
          'name'                => 'Francisca Rasmussen',
          'organization_name'   => 'Enthaze',
          'organization_id'     => 101,
          'phone'               => '8335-422-718',
          'role'                => 'admin',
          'shared'              => false,
          'signature'           => "Don't Worry Be Happy!",
          'submitted_ticket_0'  => 'A Catastrophe in Pakistan',
          'suspended'           => true,
          'tags'                => ['Springville', 'Sutton', 'Hartsville/Hartley', 'Diaperville'],
          'timezone'            =>  'Sri Lanka',
          'url'                 => 'http://initech.zendesk.com/api/v2/users/1.json',
          'verified'            => true
        }
      ]
      expect(subject.search_entities('User', '_id', '1')).to eq expected
    end
  end
end