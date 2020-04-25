require_relative './entity'
require 'json'

##
# The entity loader builds a list of entities from a JSON file
# based on an entity type, the caller only needs to specify the
# filename, the application assumes the json files are stored in
# `json` subfolder under project folder.
class EntityLoader
  attr_reader :entity_type, :filename

  def initialize(entity_type, filename)
    @entity_type = entity_type
    @filename = filename
  end

  def load
    JSON.parse(file).map { |fields| Entity.new(entity_type, fields) }
  end

  private

  def file
    @file ||= File.read(filepath)
  end

  def filepath
    File.join(File.dirname(__FILE__), '../json/', filename)
  end
end
