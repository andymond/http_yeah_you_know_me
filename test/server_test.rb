require './lib/server'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class ServerTest < Minitest::Test

  def test_server_exists
    server = Server.new

    assert_instance_of Server, server
  end

  def server_starts_when_method_called
    server = Server.new

    server.start
  end

end
