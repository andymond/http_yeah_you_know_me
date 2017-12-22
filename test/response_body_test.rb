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

  def test_html_formatter_interpolates_content_into_html
    response_body = ResponseBody.new
    content = "yo"

    assert_equal "<html><head></head><body>yo</body></html>", response_body.html_formatter(content)
  end

  def test_hello_increases_count
    response_body = ResponseBody.new

    assert_equal 0, response_body.count

    response_body.count

    assert_equal 1, response_body.count

    response_body.count

    assert_equal 2, response_body.count
  end

  def test_hello_increases_count
    response_body = ResponseBody.new

    assert_equal 0, response_body.hello_count

    response_body.hello

    assert_equal 1, response_body.hello_count

    response_body.hello

    assert_equal 2, response_body.hello_count
  end

  def test_hello_returns_string_with_hello_world_and_number
    skip
    response_body = ResponseBody.new

  end

  def test_datetime_returns_datetime
    response_body = ResponseBody.new

    assert_equal Time.now.ctime, response_body.datetime
  end

  def test_word_search_instantiates_word_finder
    response_body = ResponseBody.new
    word = "word"

    response_body.word_search(word)

    assert_instance_of WordFinder, response_body.finder
  end

  def test_word_search_finds_word
    response_body = ResponseBody.new
    word = "word"

    assert_equal "WORD is a known word", response_body.word_search(word)
  end

  def test_word_search_doesnt_find_word
    response_body = ResponseBody.new
    word = "asd!"

    assert_equal "ASD! is not a known word", response_body.word_search(word)
  end

  def test_game_starts_nil
    response_body = ResponseBody.new

    assert_nil response_body.game
  end

  def test_start_game_instantiates_guessing_game
    response_body = ResponseBody.new

    response_body.start_game

    assert_instance_of GuessingGame, response_body.game
  end

  def test_start_game_returns_good_luck
    response_body = ResponseBody.new

    assert_equal "Good Luck!", response_body.start_game
  end

end
