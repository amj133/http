require 'pry'

class WordLookup

  def initialize(word)
    @word = word
  end

  def search_dict
    dict = File.readlines("/usr/share/dict/words")
    found = dict.find do |word|
      word.chomp == @word
    end
  end

  def search_result
    return "#{@word.capitalize} is not a known word\n\n" if search_dict.nil?
    return "#{@word.capitalize} is a known word\n\n" if search_dict.nil? == false
  end

end
