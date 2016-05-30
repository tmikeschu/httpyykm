require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/ruby_server'

class RubyServerTest < Minitest::Test

  def test_it_is_a_TCP_Server
    my_server = RubyServer.new
    assert_instance_of TCPServer, my_server.server
  end

  def test_it_listens_on_port_9292_by_default
    my_server = RubyServer.new
    assert_equal 9292, my_server.port
  end

  def test_it_can_listen_on_another_port
    my_server = RubyServer.new(9291)
    assert_equal 9291, my_server.port
  end

  def test_it_responds_to_an_HTTP_request
    skip
    # result = Faraday.new
    server = RubyServer.new
    server.process_request
    response = result.get 'http://127.0.0.1:9292'
    assert_equal 'Hello', response.body
  end

  def test_number_of_times_requested_while_active_defaults_to_0
    skip
    my_server = RubyServer.new
    assert_equal 0, server.times_requested
  end

  def test_it_can_maintain_an_open_server
    skip
    my_server= RubyServer.new
    my_server.keep_open
    # More Faraday
  end

  def test_it_keeps_track_of_times_requested_while_active
    skip
    my_server = RubyServer.new
    my_server.keep_open
    # Faraday GETS request 3 times
    assert_equal 3, my_server.times_requested
  end
end
