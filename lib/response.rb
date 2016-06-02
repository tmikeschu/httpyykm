module Response

  def set_response_from_path(lines) #possible paths except game
    if requested_path(lines) == '/'
      root_path_request
    elsif requested_path(lines) == '/hello'
      hello_path_request
    elsif requested_path(lines) == '/datetime'
      datetime_path_request
    elsif requested_path(lines)[0..11] == '/word_search'
      word_search_path_request
    elsif requested_path(lines) == '/shutdown'
      shutdown_path_request
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

  def post_request_start_game_path
    if active_game?
      '403 Forbidden'
    else
      create_game
    end
  end

  def active_game?
    defined?(@game) != nil
  end

  def get_request_game_path
    if active_game?
      @game.status + "\n\n" +
      @game.compare_guess(@game.secret_number, @game.guess)
    else
      "You haven't started a game yet. POST to /start_game first."
    end
  end

  def post_request_game_path
    if active_game?
      @game.num_guesses += 1
    else
      "You haven't started a game yet. POST to /start_game first."
    end
  end

  def root_path_request
    "<pre>" + debugger(lines) + "</pre>"
  end

  def hello_path_request
    @hello_requests += 1
    "Hello, World! (#{hello_requests})"
  end

  def datetime_path_request
    Time.now.strftime("%I:%M%p on %A, %B %d, %Y")
  end

  def word_search_path_request
    "#{find_word(lines).upcase} is #{word_search(find_word(lines))} word"
  end

  def shutdown_path_request
    server.close
    "Total Requests: #{all_requests}"
  end

  def ok
    "200 OK"
  end

  def moved_permanenty
    "301 Moved Permanently"
  end

  def unauthorized
    "404 Not Found"
  end

  # def forbidden
  #   "403 Forbidden"
  # end

  # def not_found
  #   "404 Not Found"
  # end

  def internal_error
  end

end
