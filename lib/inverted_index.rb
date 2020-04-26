require 'set'

##
# This class maintains an invert index for a particular field. It maintains
# a hash `inverted_index`, for which the key is the term, and value is the
# set of entity ids whose corresponding field matches the term.
class InvertedIndex
  KEY_FOR_EMPTY = '_empty_'

  def initialize
    @inverted_index = Hash.new

    # it maintains a special set for entities whose field is empty
    create_id_set_for_term(KEY_FOR_EMPTY)
  end

  # Index an array of terms for the entity_id, here it ASSUMES that the
  # terms are already normalized already, the terms should be an array
  def index(terms, entity_id)
    if terms.empty?
      index_empty_term(entity_id)
    else
      index_terms(terms, entity_id)
    end
  end

  # Search against a search term, also it assumes the search_term is already normalized
  def search(search_term)
    return [] if id_set_for_term(search_term).nil?

    Array(id_set_for_term(search_term))
  end

  private

  attr_reader :inverted_index

  def id_set_for_term(term)
    term.nil? ? @inverted_index[KEY_FOR_EMPTY] : @inverted_index[term]
  end

  def create_id_set_for_term(term)
    set = Set.new
    inverted_index[term] = set
    set
  end

  def index_empty_term(entity_id)
    inverted_index[KEY_FOR_EMPTY].add(entity_id)
  end

  def index_terms(terms, entity_id)
    Array(terms).each do |term|
      id_set = id_set_for_term(term) || create_id_set_for_term(term)
      id_set.add(entity_id)
    end
  end
end