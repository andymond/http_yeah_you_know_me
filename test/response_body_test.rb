require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require './lib/response_body'
require './lib/request_parser'
require './lib/guessing_game'
require './lib/word_finder'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class ResponseBodyTest < Minitest::Test
  include RequestParser
  include ResponseBody

  def test_html_formatter_interpolates_content_into_html

  end

  def test_diagnostics_processes_request_lines_properly

  end

  def test_hello_increases_count

  end

  def test_hello_returns_string_with_hello_world_and_number
    assert_equal "<html><head></head><body>Hello World! (#{@hello_count})</body></html>", hello
  end

  def test_datetime_returns_datetime
    assert_equal Time.now.ctime, datetime
  end

  def test_word_search_instantiates_word_finder
    word = "word"

    word_search(word)

    assert_instance_of WordFinder, finder
  end

  def test_word_search_finds_word
    word = "word"

    assert_equal "WORD is a known word", word_search(word)
  end

  def test_word_search_doesnt_find_word
    word = "asd!"

    assert_equal "ASD! is not a known word", word_search(word)
  end

  def test_game_starts_nil
    assert_nil game
  end

  def test_start_game_instantiates_guessing_game
    start_game
    assert_instance_of GuessingGame, game
  end

  def test_start_game_returns_good_luck
    assert_equal "Good Luck!", start_game
  end

end
