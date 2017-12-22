require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require './lib/request_parser'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class RequestParserTest < Minitest::Test
  include RequestParser

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

  def test_verb_returns_verb_from_request
    assert_equal "GET", verb(GET_REQUEST)
  end

  def test_path_returns_path_from_request
    assert_equal "/", path(GET_REQUEST)
  end

  def test_protocol_returns_protocol_from_request
    assert_equal "HTTP/1.1", protocol(GET_REQUEST)
  end

  def test_host_returns_host_from_request
    assert_equal "127.0.0.1", host(GET_REQUEST)
  end

  def test_port_returns_port_from_request
    assert_equal "9292", port(GET_REQUEST)
  end

  def test_accept_returns_accept_from_request
    assert_equal "*/*", accept(GET_REQUEST)
  end

  def test_value_gets_value_from_path_parameter
    assert_equal "hi", value("/word_search?word=hi")
    assert_nil value("/")
  end

  def test_diagnostics_returns_appropriate_strings
    assert_equal "<pre>\r
Verb: GET
Path: /
Protocol: HTTP/1.1
Host: 127.0.0.1
Port: 9292
Origin: 127.0.0.1
Accept:*/*</pre>", diagnostics(GET_REQUEST)
    assert_equal "<pre>\r
Verb: POST
Path: /hello
Protocol: HTTP/1.1
Host: 127.0.0.1
Port: 9292
Origin: 127.0.0.1
Accept:*/*</pre>", diagnostics(POST_REQUEST)
  end

  def test_get_content_length_returns_content_length_integer
    assert_equal 224, get_content_length(POST_REQUEST)
    assert_nil get_content_length(GET_REQUEST)
  end

end
