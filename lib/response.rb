module Response
  def headers(output, responde_code = '200 OK', location = '')
    headers = ["http/1.1 #{responde_code}",
               "location: #{location}",
               "date: #{Time.now.strftime('%a, %e %b %Y %H:%M:%S %z')}",
               'server: ruby',
               'content-type: text/html; charset=iso-8859-1',
               "content-length: #{output.length}\r\n\r\n"].join("\r\n")
  end

  def select_http_status_codes
    { 'Goo' => '301 Moved Permanently',
      '401' => '401 Unauthorized',
      '403' => '403 Forbidden',
      '404' => '404 Not Found',
      '500' => '500 Internal Server Error' }
  end

  def set_response_from_path(lines)
    if requested_path(lines) == '/'
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
      internal_error(lines)
    else
      check_unauthorized_requests(lines)
    end
  end

  def check_unauthorized_requests(lines)
    unauthorized = %w(/hello /datetime /shutdown)
    if post?(lines) && (requested_path(lines)[0..11] == '/word_search' ||
       unauthorized.include?(requested_path(lines)))
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
    check_type_of_request(lines) == 'POST'
  end

  def get?(lines)
    check_type_of_request(lines) == 'GET'
  end

  def post_request_start_game_path
    if active_game?
      '403 Forbidden'
    else
      'Good luck!' && create_game
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

  def root_path_request(_lines)
    '<pre>' + + '</pre>'
  end

  def hello_path_request
    @hello_requests += 1
    "Hello, World! (#{hello_requests})"
  end

  def datetime_path_request
    Time.now.strftime('%I:%M%p on %A, %B %d, %Y')
  end

  def word_search_path_request(lines)
    "#{find_word(lines).upcase} is #{word_search(find_word(lines))} word"
  end

  def shutdown_path_request
    server.close
    "Total Requests: #{all_requests}"
  end

  def internal_error(_lines)
    "500 Internal Server Error\n\n" + '<pre>' + error_log + '</pre>'
  end

  def error_log
    raise 'SystemError'
  rescue => exception
    exception.backtrace.join("\n\t")
  end
end
