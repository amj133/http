require 'minitest/autorun'
require 'minitest/pride'
require './lib/word_lookup'

class WordLookupTest < Minitest::Test

  def test_it_exists
    seeker = WordLookup.new("monkey")

    assert_instance_of WordLookup, seeker
  end

  def test_search_dict_finds_word_if_present
    seeker_1 = WordLookup.new("monkey")
    seeker_2 = WordLookup.new("monkpoopey")

    assert_equal "monkey\n", seeker_1.search_dict
    assert_nil seeker_2.search_dict
  end

  def test_search_dict_returns_known_word_if_present_in_dict
    seeker_1 = WordLookup.new("monkey")
    seeker_2 = WordLookup.new("gorilla")
    seeker_3 = WordLookup.new("monkpoopey")

    seeker_1.search_dict
    seeker_2.search_dict
    seeker_3.search_dict

    assert_equal "Monkey is a known word\n\n", seeker_1.search_result
    assert_equal "Gorilla is a known word\n\n", seeker_2.search_result
    assert_equal "Monkpoopey is not a known word\n\n", seeker_3.search_result
  end

end
