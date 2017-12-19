require './lib/guessing_game'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test

  def test_it_exists
    game = GuessingGame.new("guess")

    assert_instance_of GuessingGame, game
  end

  def test_takes_arguement
    game = GuessingGame.new("guess")

    assert_equal "guess", game.guess
  end

  def test_number_generator_generates_integer
    game = GuessingGame.new("guess")

    assert_instance_of Integer, game.number_generator
  end

  def test_number_generator_generates_number_in_range
    game = GuessingGame.new("guess")

    assert game.number_generator.between?(0, 100)
  end

  def test_number_detects_numbers_in_input
    game = GuessingGame.new("guess")

    assert game.number?("1")
    assert game.number?(1)
    refute game.number?("a")
  end

  def test_guess_validator_rejects_non_numeric_input
    game = GuessingGame.new("guess")

    assert_equal "That's not a number! Try again.", game.guess_validator
  end

  def test_guess_match_returns_match_based_on_match
    skip
    game = GuessingGame.new(1)

    assert_equal "You guessed it!", game.guess_match
  end

end
