require './lib/request_parser'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class RequestParserTest < Minitest::Test

  def test_it_exists
    parser = RequestParser

    assert_instance_of RequestParser, parser
  end

end
