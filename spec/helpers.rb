##
# Define some common helper methods that can be used by all specs
module Helpers
  # Load entities from the fixtures json file in spec/fixtures
  def load_entities_from_fixture(entity_type, fixture_file)
    fixture = File.read(File.join(File.dirname(__FILE__), './fixtures', fixture_file))
    JSON.parse(fixture).map do |fields|
      Entity.new(entity_type, fields)
    end
  end
end