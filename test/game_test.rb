require 'minitest/autorun'
require 'minitest/pride'
require './lib/game.rb'

class GameTest < Minitest::Test
  def test_it_tracks_num_guesses_and_defaults_to_0
    game = Game.new
    assert_equal 0, game.num_guesses
  end
end
