require 'minitest/autorun'
require 'minitest/pride'
require './lib/guessing_game'
require 'pry'

class GuessingGameTest < Minitest::Test

  def test_it_exists
    game = GuessingGame.new(13)

    assert_instance_of GuessingGame, game
  end

  def test_game_contains_a_guess
    game = GuessingGame.new(13)

    assert_equal 13, game.guess
  end

  def test_game_contains_a_secret_number_between_1_and_100
    game = GuessingGame.new(13)

    assert game.secret_number < 101 && game.secret_number > -1
  end

end
