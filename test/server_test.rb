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

  def test_hello_world
    response = Faraday.get "http://127.0.0.1:9292/hello"

    assert_equal "<html><head></head><body><html><head></head><body>Hello World! (1)</body></html><pre>\r
Verb: GET
Path: /hello
Protocol: HTTP/1.1
Host: 127.0.0.1
Port: 9292
Origin: 127.0.0.1
Accept:gzip;q=1.0,deflate;q=0.6,identity;q=0.3</pre></body></html>", response.body
  end

end
