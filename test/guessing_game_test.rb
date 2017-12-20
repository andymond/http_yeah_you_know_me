require './lib/guessing_game'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class GameTest < Minitest::Test

  def test_it_exists
    game = GuessingGame.new

    assert_instance_of GuessingGame, game
  end

  def test_guess_initializes_nil
    game = GuessingGame.new

    assert_nil game.guess
  end

  def test_guess_count_starts_at_zero
    game = GuessingGame.new

    assert game.guess_count.zero?
  end

  def test_guess_count_goes_up_with_guesses
    game = GuessingGame.new
    game.play(1)
    game.play(3)

    assert_equal 2, game.guess_count

    game.play("kookie krisps")

    assert_equal 3, game.guess_count
  end

  def test_guess_can_change
    game = GuessingGame.new

    assert_equal "guess", game.guess = "guess"
  end

  def test_number_generator_generates_integer
    game = GuessingGame.new

    assert_instance_of Integer, game.number_generator
  end

  def test_number_generator_generates_number_in_range
    game = GuessingGame.new

    assert game.number_generator.between?(0, 100)
  end

  def test_number_detects_numbers_in_input
    game = GuessingGame.new

    assert game.number?("1")
    assert game.number?(1)
    refute game.number?("a")
  end

  def test_guess_validator_rejects_non_numeric_input
    game = GuessingGame.new
    game.guess = "guess"

    assert_equal "That's not a number! Try again.", game.guess_validator
  end

  def test_guess_match_returns_match_based_on_match
    game = GuessingGame.new(1,1)
    game.guess = 1

    assert_equal "You guessed it!", game.guess_match
  end

  def test_guess_match_returns_too_low_if_guess_low
    game = GuessingGame.new(1,1)
    game.guess = 0

    assert_equal "Too low! Guess again!", game.guess_match
  end

  def test_guess_match_returns_too_hi_if_guess_hi
    game = GuessingGame.new(1,1)
    game.guess = 2

    assert_equal "Too high! Guess again!", game.guess_match
  end

  def test_guess_can_change
    game = GuessingGame.new
    game.guess = 1

    assert_equal 1, game.guess

    game.guess = 3

    assert_equal 3, game.guess
  end

end
