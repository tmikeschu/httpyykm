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

  def test_number_of_times_requested_while_active_defaults_to_negative_one
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

  def test_it_can_format_request_lines_for_debugger
    my_server = RubyServer.new
    lines = ["GET / HTTP/1.1", "Host: 127.0.0.1:9292", "Connection: keep-alive",
             "Cache-Control: no-cache", "User-Agent: Mozilla/5.0",
             "Postman-Token: 602c9eaf-23a7-276a-f55b-59f1cf0ee4c2",
             "Accept: */*, Accept-Encoding: gzip, deflate, Accept-Language: en-US"]
    result = "Verb: GET\nPath: /\nProtocol: HTTP/1.1\nHost: 127.0.0.1\nPort: 9292\nOrigin: #{`ipconfig getifaddr en0`.chomp.to_s}\nAccept: */*, Accept-Encoding"
    assert_equal result, my_server.debugger(lines)
    my_server.server.close
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
