class Game
  attr_accessor :num_guesses,
                :guess
  attr_reader   :secret_number

  def initialize
    @num_guesses = 0
    @secret_number
    @guess
  end

  def start_game
    @secret_number = rand_number
    'Good luck!'
  end

  def status
    "You've taken #{num_guesses} guesses."
  end

  def rand_number
    rand(0..100)
  end

  def compare_guess(secret, guess)
    return 'No guesses.' if secret.nil? || guess.nil?
    return 'Your guess is correct!' if secret == guess
    difference = secret > guess ? 'too low.' : 'too high.'
    "Your guess is #{difference}"
  end
end
