require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/ruby_server'

class RubyServerTest < Minitest::Test

  def test_it_is_a_TCP_Server
    server = RubyServer.new
    assert_instance_of TCPServer, server.server
  end

  def test_it_listens_on_port_9292_by_default
    server = RubyServer.new
    assert_equal 9292, server.port
  end

  def test_it_responds_to_an_HTTP_request
    # skip
    result = Faraday.new
    server = RubyServer.new
    server.process_request
    response = result.get 'http://127.0.0.1:9292'
    assert_equal 'Hello', response.body
  end
end
