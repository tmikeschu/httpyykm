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

  def test_number_of_times_hello_requests_while_active_defaults_to_negative_one
    my_server = RubyServer.new
    assert_equal -1, my_server.hello_requests
    my_server.server.close
  end

  def test_number_of_times_all_requests_while_active_defaults_to_zero
    my_server = RubyServer.new
    assert_equal 0, my_server.all_requests
    my_server.server.close
  end

  # Note: RubyServer must be running separately for the following tests to pass

  def test_it_responds_to_an_HTTP_request
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    assert_instance_of String, response.body
  end

  def test_if_root_is_requested_HTTP_responds_with_full_debug
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292'
    refute_equal 'Hello, World!', response.body[25...38]
  end

  def test_if_root_hello_is_requested_HTTP_responds_with_hello_counter_only
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/hello'
    assert_equal 'Hello, World!', response.body[25...38]
  end

  def test_it_can_take_a_word_parameter_and_search_the_dictionary
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/word_search?word=tree'
    assert_equal 'TREE is a known word', response.body[25...45]
  end

  def test_HTTP_response_for_start_game_path
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/start_game'
    assert_equal 'Good luck!', response.body[25...35]
  end

end
