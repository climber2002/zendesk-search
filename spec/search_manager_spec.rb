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

    it 'can search tickets with some dirty data in tickets data' do
      expected = [
        {
          '_id'                 => '436bf9b0-1147-4c0a-8439-6f79833bff5b',
          'url'                 => 'http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json',
          'external_id'         => '9210cdc9-4bee-485f-a078-35396cd74063',
          'type'                => 'incident',
          'created_at'          => '2016-04-28T11:19:34 -10:00',
          'subject'             => 'A Catastrophe in Korea (North)',
          'description'         => 'Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.',
          'priority'            => 'high',
          'status'              => 'pending',
          'submitter_id'        => 38,
          'assignee_id'         => 24,
          'organization_id'     => 101,
          'tags'                => ['Ohio', 'Pennsylvania', 'American Samoa', 'Northern Mariana Islands'],
          'has_incidents'       => false,
          'due_at'              => '2016-07-31T02:37:50 -10:00',
          'via'                 => 'web',
          'assignee_name'       => "Can't find User with id 24",
          'organization_name'   => 'Enthaze',
          'submitter_name'      => "Can't find User with id 38"
        }
      ]

      expect(subject.search_entities('Ticket', '_id', '436bf9b0-1147-4c0a-8439-6f79833bff5b')).to eq expected
    end
  end
end