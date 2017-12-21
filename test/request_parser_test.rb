require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require './lib/request_parser'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class RequestParserTest < Minitest::Test

  GET_REQUEST = [ "GET / HTTP/1.1",
                  "Host: 127.0.0.1:9292",
                  "Connection: keep-alive",
                  "Cache-Control: no-cache",
                  "Content-Type: application/x-www-form-urlencoded",
                  "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36",
                  "Postman-Token: 02399df8-40c2-eb59-4bbd-72d5b71a4f6d",
                  "Accept: */*",
                  "Accept-Encoding: gzip, deflate, br",
                  "Accept-Language: en-US,en;q=0.9"]

  POST_REQUEST = [ "POST /hello HTTP/1.1",
                   "Host: 127.0.0.1:9292",
                   "Connection: keep-alive",
                   "Content-Length: 224",
                   "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Safari/537.36",
                   "Cache-Control: no-cache",
                   "Origin: chrome-extension://fhbjgbiflinjbdggehcddcbncdddomop",
                   "Postman-Token: 07ed541d-fcd9-0b75-10c8-3fc62057f728",
                   "Content-Type: application/x-www-form-urlencoded",
                   "Accept: */*",
                   "Accept-Encoding: gzip, deflate, br",
                   "Accept-Language: en-US,en;q=0.9"]

  def test_it_exists
    parser = RequestParser.new

    assert_instance_of RequestParser, parser
  end

  def test_verb_returns_verb_from_request
    parser = RequestParser.new

    assert_equal "GET", parser.verb(GET_REQUEST)
  end

  def test_path_returns_path_from_request
    parser = RequestParser.new

    assert_equal "/", parser.path(GET_REQUEST)
  end

  def test_protocol_returns_protocol_from_request
    parser = RequestParser.new

    assert_equal "HTTP/1.1", parser.protocol(GET_REQUEST)
  end

  def test_host_returns_host_from_request
    parser = RequestParser.new

    assert_equal "127.0.0.1", parser.host(GET_REQUEST)
  end

  def test_port_returns_port_from_request
    parser = RequestParser.new

    assert_equal "9292", parser.port(GET_REQUEST)
  end

  def test_accept_returns_accept_from_request
    parser = RequestParser.new

    assert_equal "*/*", parser.accept(GET_REQUEST)
  end

  def test_value_gets_value_from_path_parameter
    parser = RequestParser.new

    assert_equal "hi", parser.value("/word_search?word=hi")
    assert_nil parser.value("/")
  end

  def test_post_processor_returns_content_length_integer
    parser = RequestParser.new

    assert_equal 224, parser.get_content_length(POST_REQUEST)
    assert_nil parser.get_content_length(GET_REQUEST)
  end

  def test_get_guess_returns_post_body_value

  end

end
