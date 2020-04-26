class ListSearchableFieldsCommand
  def initialize(search_manager)
    @search_manager = search_manager
  end

  def run
    searchable_fields = search_manager.searchable_fields
    searchable_fields.each do |entity_type, field_names|
      puts '---------------------------------------------------'
      puts "Search #{entity_type}s with"
      field_names.each { |field_name| puts field_name }
      puts ''
    end
  end

  private

  attr_reader :search_manager
end