require 'singleton'
require_relative './base_normalizer'

##
# Text Normalizer will do following normalization:
# - Convert Latin characters such as ö to modern character o 
# - Remove normal punctuations such as comma, apostrophe
# - Lowercase all characters
class TextNormalizer
  include Singleton
  include BaseNormalizer

  # Non-ASCII characters to replace
  NON_ASCII_CHARS        = 'ÀÁÂÃÄÅàáâãäåĀāĂăĄąÇçĆćĈĉĊċČčÐðĎďĐđÈÉÊËèéêëĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħÌÍÎÏìíîïĨĩĪīĬĭĮįİıĴĵĶķĸ' \
                           'ĹĺĻļĽľĿŀŁłÑñŃńŅņŇňŉŊŋÒÓÔÕÖØòóôõöøŌōŎŏŐőŔŕŖŗŘřŚśŜŝŞşŠšſŢţŤťŦŧÙÚÛÜùúûüŨũŪūŬŭŮůŰűŲųŴŵÝýÿŶŷŸŹźŻżŽž'
  # "Equivalent" ASCII characters
  EQUIVALENT_ASCII_CHARS = 'AAAAAAaaaaaaAaAaAaCcCcCcCcCcDdDdDdEEEEeeeeEeEeEeEeEeGgGgGgGgHhHhIIIIiiiiIiIiIiIiIiJjKkk' \
                           'LlLlLlLlLlNnNnNnNnnNnOOOOOOooooooOoOoOoRrRrRrSsSsSsSssTtTtTtUUUUuuuuUuUuUuUuUuUuWwYyyYyYZzZzZz'

  def normalize_field_value_impl(value)
    replace_non_characters(value).gsub(/[[:punct:]]/, '').downcase
  end

  private

  def replace_non_characters(value)
    value.tr(NON_ASCII_CHARS, EQUIVALENT_ASCII_CHARS)
  end
end