require 'minitest/autorun'
require 'minitest/pride'
require './lib/guessing_game'

class GuessingGameTest < Minitest::Test

  def test_it_exists
    game = GuessingGame.new

    assert_instance_of GuessingGame, game
  end

  def test_game_contains_a_secret_number_between_1_and_100
    game = GuessingGame.new

    assert game.secret_number < 101 && game.secret_number > -1
  end

  def test_guess_count_increases_with_each_comparison
    game = GuessingGame.new

    assert_equal 0, game.guess_count

    game.compare(13)
    game.compare(14)
    game.compare(15)

    assert_equal 3, game.guess_count
  end

  def test_compare_returns_a_string
    game = GuessingGame.new

    assert_instance_of String, game.compare(15)
    assert_instance_of String, game.compare(-5)
    assert_instance_of String, game.compare(110)
  end

end
