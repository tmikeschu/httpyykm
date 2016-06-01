require './lib/game_mechanics'
require './lib/parse_and_format'

class Game
  attr_accessor :num_guesses

  include GameMechanics, ParseAndFormat

  def initialize
    @num_guesses = 0
  end

  def start_game
    rand_number
    "Good luck!"
  end
end
