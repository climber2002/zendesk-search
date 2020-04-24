require_relative './entity'
require 'json'

# The entity loader builds a list of entities from a JSON file
# based on a entity type
class EntityLoader
  attr_reader :entity_type, :filename

  ##
  # The filename assumes that the file is saved in the json folder
  def initialize(entity_type, filename)
    @entity_type = entity_type
    @filename = filename
  end

  def load
    JSON.parse(file).map { |fields| Entity.new(entity_type, fields) }
  end

  private

  def file
    @file ||= File.read(File.join(File.dirname(__FILE__), '../json/', filename))
  end
end
