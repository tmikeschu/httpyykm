require 'socket'
require './lib/parse_and_format'
require './lib/game'
require './lib/response'

class RubyServer
  attr_reader :server,
              :port,
              :hello_requests,
              :all_requests,
              :game

  include ParseAndFormat, Response

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
    @hello_requests = -1
    @all_requests = 0
  end

  def keep_open
    while true
      process_request
    end
  end

  private

  def process_request
    client = server.accept
    @all_requests += 1
    lines = request_lines(client)
    user_guess = read_from_post_request(client, find_content_length(lines))
    check_and_set_guess(lines, user_guess)
    response = set_response_from_path(lines)
    body = "<html><head></head><body>#{response}</body></html>"
    header_assignment(body, lines, client, response)
    client.puts body
    client.close
  end

  def header_assignment(body, lines, client, response)
    if requested_path(lines) == '/game?guess' && post?(lines)
      client.puts headers(body, "302 Redirect", 'http://127.0.0.1:9292/game')
    elsif response == 'Good luck!'
      client.puts headers(body, '301 Moved Permanently')
    elsif response == '401 Unauthorized'
      client.puts headers(body, '401 Unauthorized')
    elsif response == '403 Forbidden'
      client.puts headers(body, '403 Forbidden')
    elsif response == '404 Not Found'
      client.puts headers(body, '404 Not Found')
    elsif response == '500 Internal Server Error'
      client.puts headers(body, '500 Internal Server Error')
    else
      client.puts headers(body)
    end
  end

  def request_lines(client)
    received = []
    while line = client.gets and !line.chomp.empty?
      received << line.chomp
    end
    received
  end

  def create_game
    @game = Game.new
    game.start_game
  end

  def check_and_set_guess(lines, user_guess)
    game.guess = user_guess if active_game? && post?(lines)
  end

end
