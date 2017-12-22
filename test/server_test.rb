require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'

class ServerTest < Minitest::Test

  def test_root_url
    response = Faraday.get "http://127.0.0.1:9292/"

    assert_equal "<html><head></head><body><pre>\r\nVerb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: 127.0.0.1\nAccept:gzip;q=1.0,deflate;q=0.6,identity;q=0.3</pre></body></html>", response.body
  end

  def test_hello_world_url
    response = Faraday.get "http://127.0.0.1:9292/hello"

    assert response.body.include?("Hello World")
  end

  def test_word_search_status
    response = Faraday.get "http://127.0.0.1:9292/hello"

    assert_equal 200, response.status
  end

  def test_date_time_url
    response = Faraday.get "http://127.0.0.1:9292/datetime"

    assert response.body.include?(Time.now.ctime)
  end

  def test_datetime_status
    response = Faraday.get "http://127.0.0.1:9292/datetime"

    assert_equal 200, response.status
  end

  def test_word_search_url
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=thing"

    assert_equal "<html><head></head><body>THING is a known word</body></html>", response.body
  end

  def test_word_search_status
    response = Faraday.get "http://127.0.0.1:9292/word_search?word=thing"

    assert_equal 200, response.status
  end

  def test_start_game_url_post
    response = Faraday.post "http://127.0.0.1:9292/start_game"

    assert_equal "<html><head></head><body>Good Luck!</body></html>", response.body
  end

  def test_start_game_url_post_status
    response = Faraday.post "http://127.0.0.1:9292/start_game"

    assert_equal 301, response.status
  end

  def test_game_url_post
    response = Faraday.post "http://127.0.0.1:9292/game"

    assert_equal  "<html><head></head><body>That's not a number! Try again.</body></html>", response.body
  end

  def test_game_url_post_status
    response = Faraday.post "http://127.0.0.1:9292/game"

    assert_equal 301, response.status
  end

  def test_force_error_url_status
    response = Faraday.post "http://127.0.0.1:9292/force_error"

    assert_equal 500, response.status
  end

  def test_not_found_status
    response = Faraday.post "http://127.0.0.1:9292/asdfasd"

    assert_equal 404, response.status
  end

end
