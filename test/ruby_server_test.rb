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

  def test_number_of_times_requested_while_active_defaults_to_-1
    my_server = RubyServer.new
    assert_equal -1, my_server.times_requested
    my_server.server.close
  end

  # Note: RubyServer must be running separately for the following tests to pass

  def test_it_responds_to_an_HTTP_request
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    assert_instance_of String, response.body
  end

  def test_it_responds_to_an_HTTP_request_in_a_formatted_manner
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    assert_equal 'Verb:', response.body[50..54]
  end

  def test_if_root_is_requested_HTTP_responds_with_full_debug
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    #assert debugger
  end

  def test_if_root_hello_is_requested_HTTP_responds_with_hello_counter_only
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/hello'
    assert_equal 'Hello, World!', response.body[0...12]
    # assert_equal 16.response.body.length
  end
#counter doesn't increment if other path is selected

end
