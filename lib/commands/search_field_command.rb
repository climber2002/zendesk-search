require_relative '../search_error'

class SearchFieldCommand
  def initialize(search_manager)
    @search_manager = search_manager
    @entity_type_names = { '1' => 'User', '2' => 'Ticket', '3' => 'Organization' }
  end

  def run
    read_entity_type_to_search
    read_field_to_search
    read_value_to_search
    search
  rescue SearchError => exception
    puts "Error occurred while searching: #{exception.message}"
  end

  private

  attr_reader :search_manager, :entity_type_names
  attr_reader :entity_type_to_search, :field_to_search, :value_to_search

  def read_entity_type_to_search
    print_select_entity_type_instruction
    @entity_type_to_search = entity_type_names[$stdin.readline.chomp]
    until entity_type_to_search_valid?
      puts "Not valid selection"
      print_select_entity_type_instruction
      @entity_type_to_search = entity_type_names[$stdin.readline.chomp]
    end
  end

  def read_field_to_search
    puts "Enter search field"
    @field_to_search = $stdin.readline.chomp
    until field_to_seach_valid?
      puts "Invalid field, only the following fields are allowed"
      print_searchable_fields
      puts "Enter search field"
      @field_to_search = $stdin.readline.chomp
    end
  end

  def read_value_to_search
    puts "Enter search value (just press Enter to search empty value)"
    @value_to_search = $stdin.readline.chomp
  end

  def print_select_entity_type_instruction
    puts "Select 1) Users or 2) Tickets or 3) Organizations"
  end

  def entity_type_to_search_valid?
    !entity_type_to_search.nil?
  end

  def field_to_seach_valid?
    searchable_fields.include?(field_to_search)
  end

  def print_searchable_fields
    puts '---------------------------------------------------'
    searchable_fields.each { |field| puts field }
    puts ''
  end

  def searchable_fields
    search_manager.searchable_fields[entity_type_to_search]
  end

  def search
    puts ''
    print_searching_info
    search_result = search_manager.search_entities(entity_type_to_search, field_to_search, value_to_search)
    if(search_result.empty?)
      puts 'No results found'
    else
      print_search_result(search_result)
    end
    puts ''
  end

  def print_searching_info
    info = if value_to_search.empty?
      "Searching #{entity_type_to_search.downcase}s for #{field_to_search} with empty value"
    else
      "Searching #{entity_type_to_search.downcase}s for #{field_to_search} with a value of #{value_to_search}"
    end
    puts info
  end

  def print_search_result(search_result)
    puts "Found #{search_result.count} result(s)"
    search_result.each do |entity_fields|
      puts '---------------------------------------------------'
      entity_fields.each do |field_name, field_value|
        puts "%-25s %s" % [field_name, field_value]
      end
    end
  end
end