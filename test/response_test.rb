require 'minitest/autorun'
require 'minitest/pride'
require 'faraday'
require './lib/response'
require './lib/game.rb'

class ResponseTest < Minitest::Test


# Add a test When you submit the POST to /start_game and there is no game in progress, it should start one and respond with a 301 redirect. -> affects header

  def test_if_game_has_started_a_second_post_request_gives_a_403_code
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/start_game'
    response = request.post 'http://127.0.0.1:9292/start_game'
    assert_equal '403 Forbidden', response.body[25...38]
  end

  def test_that_if_requested_an_unknow_path_HTTP_responds_with_404_code
    request = Faraday.new
    response = request.get 'http://127.0.0.1:9292/fofamalou'
    assert_equal '404 Not Found', response.body[25...38]
  end

  def test_that_post_requests_made_on_paths_available_for_get_only_respond_with_unauthorized_code
    request = Faraday.new
    response = request.post 'http://127.0.0.1:9292/hello'
    assert_equal '401 Unauthorized', response.body[25...41]
  end

end
