require './lib/server'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def test_count_starts_at_zero

  end

  def test_server_starts_when_method_called
    server = Server.new

    server.start
  end

  def test_count_increases_by_one_each_start

  end

  def test_request_returns_array

  end

  def test_response_control
  end

  def test_respond_returns_string

  end

end
