require_relative './search_manager'
require_relative './entity_loader'
require_relative './entity_type'
require_relative './commands/search_field_command'
require_relative './commands/list_searchable_fields_command'

##
# This is the entrypoint of the console application
class Runner

  def initialize
    initialize_search_manager
  end

  def run
    puts 'Welcome to Zendesk Search'
    puts "Type 'quit' to exit at any time, Press 'Enter' to continue"
    print_hint

    while (line = $stdin.readline.chomp) && !quit_command?(line)
      run_command(line)
      print_hint
    end
  end

  private

  attr_reader :search_manager

  def print_hint
    2.times { puts '' }
    puts "\tSelect search options:"
    puts "\t * Press 1 and 'Enter' to search Zendesk"
    puts "\t * Press 2 and 'Enter' to view a list of searchable fields"
    puts "\t * Type 'quit' to exit"
  end

  def run_command(line)
    if line == '1'
      SearchFieldCommand.new(search_manager).run
    elsif line == '2'
      ListSearchableFieldsCommand.new(search_manager).run
    else
      puts 'Unknown command'
      print_hint
    end
  end

  def quit_command?(line)
    line.downcase == 'quit'
  end

  def initialize_search_manager
    @search_manager = SearchManager.new
    all_entities_by_type.each do |entities|
      entities.each { |entity| @search_manager.add_entity(entity) }
    end
  end

  def all_entities_by_type
    organizations = EntityLoader.new(EntityType::ORGANIZATION_TYPE, 'organizations.json').load
    users         = EntityLoader.new(EntityType::USER_TYPE, 'users.json').load
    tickets       = EntityLoader.new(EntityType::TICKET_TYPE, 'tickets.json').load
    [organizations, users, tickets]
  end
end