require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/ruby_server'

class RubyServerTest < Minitest::Test

  def test_it_is_a_TCP_Server
    my_server = RubyServer.new
    assert_instance_of TCPServer, my_server.server
    my_server.server.close
  end

  def test_it_listens_on_port_9292_by_default
    my_server = RubyServer.new
    assert_equal 9292, my_server.port
    my_server.server.close
  end

  def test_it_can_listen_on_another_port
    my_server = RubyServer.new(9291)
    assert_equal 9291, my_server.port
    my_server.server.close
  end

  def test_number_of_times_requested_while_active_defaults_to_0
    my_server = RubyServer.new
    assert_equal 0, my_server.times_requested
    my_server.server.close
  end

  # Note: RubyServer must be running separately for the following tests to pass

  def test_it_responds_to_an_HTTP_request
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    assert_instance_of String, response.body
  end

  def test_it_keeps_track_of_times_requested_while_active
    skip
    request = Faraday.new
    response_two = request.get 'http://127.0.0.1:9292'
    assert_equal "Hello, World! (2)", response_two.body[25..41]
  end
end
