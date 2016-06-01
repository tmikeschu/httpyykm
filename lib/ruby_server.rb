require 'socket'
require './lib/parse_and_format'
require './lib/game'

class RubyServer
  attr_reader :server,
              :port,
              :hello_requests,
              :all_requests

  include ParseAndFormat

  def initialize(port = 9292)
    @server = TCPServer.new(port)
    @port = port
    @hello_requests = -1
    @all_requests = 0
  end

  def process_request
    client = server.accept
    @all_requests += 1
    lines = request_lines(client)
    check_and_set_guess(read_from_post_request(client, find_content_length(lines)))
    response = set_response_from_path(lines)
    body = "<html><head></head><body>#{response}</body></html>"
    if requested_path(lines)[0..4] == '/game' && post?(lines)
      client.puts headers(body, "302 redirect")
    else
      client.puts headers(body)
    end
    client.puts body
    client.close
    require 'pry'; binding.pry
  end

  def request_lines(client)
    received = []
    while line = client.gets and !line.chomp.empty?
      received << line.chomp
    end
    received
  end

  def headers(output, responde_code = '200 ok', location = "")
    headers = ["http/1.1 #{responde_code}",
              "location: #{location}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              'server: ruby',
              'content-type: text/html; charset=iso-8859-1',
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def keep_open
    while true
      process_request
    end
  end

  def set_response_from_path(lines)
    if requested_path(lines) == '/'
      "<pre>" + debugger(lines) + "</pre>"
    elsif requested_path(lines) == '/hello'
      @hello_requests += 1
      "Hello, World! (#{hello_requests})"
    elsif requested_path(lines) == '/datetime'
      Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
    elsif requested_path(lines)[0..11] == '/word_search'
      "#{find_word(lines).upcase} is #{word_search(find_word(lines))} word"
    elsif requested_path(lines) == '/shutdown'
      server.close
      "Total Requests: #{all_requests}"
    else
      set_response_for_game_paths(lines)
    end
  end

  def set_response_for_game_paths(lines)
    if requested_path(lines) == '/start_game' && post?(lines)
      create_game
    elsif requested_path(lines) == '/game' && get?(lines)
      if active_game?
        @game.status
      else
        "You haven't started a game yet. POST to /start_game first."
      end
    elsif requested_path(lines)[0..4] == '/game' && post?(lines)
      if active_game?
        binding.pry
        @game.num_guesses += 1
        @game.compare_guess(@game.secret_number, @game.guess)
      else
        "You haven't started a game yet. POST to /start_game first."
      end
    end
  end

  def active_game?
    defined?(@game) != nil
  end

  def check_and_set_guess(user_guess)
    @game.guess = user_guess if active_game?
  end

  def create_game
    @game = Game.new
    @game.start_game
  end

  def post?(lines)
    check_type_of_request(lines) == "POST"
  end

  def get?(lines)
    check_type_of_request(lines) == "GET"
  end

end
