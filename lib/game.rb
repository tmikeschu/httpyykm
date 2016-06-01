require './lib/game_mechanics'
require './lib/parse_and_format'

class Game
  attr_accessor :num_guesses,
                :guess
  attr_reader   :secret_number

  include GameMechanics, ParseAndFormat

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
end
