require './lib/route'
require 'minitest'
require 'minitest/autorun'
require 'minitest/pride'

class RouteTest < Minitest::Test

  def test_route_exists
    route = Route.new

    assert_instance_of Route, route
  end

  def test_router_leads_to_root_if_path_is_forward_slash
    route = Route.new

    assert_equal "root", route.router("/")
  end

end
