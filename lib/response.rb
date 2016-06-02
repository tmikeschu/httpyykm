module Response

  def headers(output, responde_code = '200 OK', location = "")
    headers = ["http/1.1 #{responde_code}",
              "location: #{location}",
              "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
              'server: ruby',
              'content-type: text/html; charset=iso-8859-1',
              "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def set_response_from_path(lines) #possible paths except game
    if requested_path(lines) == '/' && get?(lines)
      root_path_request(lines)
    elsif requested_path(lines) == '/hello' && get?(lines)
      hello_path_request
    elsif requested_path(lines) == '/datetime' && get?(lines)
      datetime_path_request
    elsif requested_path(lines)[0..11] == '/word_search' && get?(lines)
      word_search_path_request(lines)
    elsif requested_path(lines) == '/shutdown' && get?(lines)
      shutdown_path_request
    elsif requested_path(lines) == '/force_error'
      internal_error
    else
      check_unauthorized_requests(lines)
    end
  end

  def check_unauthorized_requests(lines)
    if requested_path(lines) == '/' && post?(lines) ||
       requested_path(lines) == '/hello' && post?(lines) ||
       requested_path(lines) == '/datetime' && post?(lines) ||
       requested_path(lines)[0..11] == '/word_search' && post?(lines) ||
       requested_path(lines) == '/shutdown' && post?(lines)
       '401 Unauthorized'
    else
      set_response_for_game_paths(lines)
    end
  end

  def set_response_for_game_paths(lines)
    if requested_path(lines) == '/start_game' && post?(lines)
      post_request_start_game_path
    elsif requested_path(lines) == '/game' && get?(lines)
      get_request_game_path
    elsif requested_path(lines)[0..4] == '/game' && post?(lines)
      post_request_game_path
    else
      '404 Not Found'
    end
  end

  def post?(lines)
    check_type_of_request(lines) == "POST"
  end

  def get?(lines)
    check_type_of_request(lines) == "GET"
  end

  def post_request_start_game_path
    if active_game?
      '403 Forbidden'
    else
      create_game && 'Good luck!'
    end
  end

  def active_game?
    defined?(@game) != nil
  end

  def get_request_game_path
    if active_game?
      game.status + "\n\n" +
      game.compare_guess(game.secret_number, game.guess)
    else
      "You haven't started a game yet. POST to /start_game first."
    end
  end

  def post_request_game_path
    if active_game?
      game.num_guesses += 1
    else
      "You haven't started a game yet. POST to /start_game first."
    end
  end

  def root_path_request(lines)
    "<pre>" + debugger(lines) + "</pre>"
  end

  def hello_path_request
    @hello_requests += 1
    "Hello, World! (#{hello_requests})"
  end

  def datetime_path_request
    Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
  end

  def word_search_path_request(lines)
    "#{find_word(lines).upcase} is #{word_search(find_word(lines))} word"
  end

  def shutdown_path_request
    server.close
    "Total Requests: #{all_requests}"
  end

  def moved_permanenty #haven't used this method yet
    "301 Moved Permanently"
  end

  def internal_error
    '500 Internal Server Error'
  end

end
